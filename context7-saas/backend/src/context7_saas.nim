## Context7 SaaS Backend Server
## RESTful API server for Context7 cloud service

import std/[asyncdispatch, json, strutils, times, tables, options, os]
import jester
import jsony
import chronicles
import jwt
import bcrypt
import db_postgres
import redis
import uuids
import ../../shared/src/shared_logic

# Configuration
type
  Config = object
    host: string
    port: int
    dbHost: string
    dbPort: int
    dbName: string
    dbUser: string
    dbPass: string
    redisHost: string
    redisPort: int
    jwtSecret: string
    corsOrigins: seq[string]

# Models
type
  User = object
    id: string
    email: string
    passwordHash: string
    organization: string
    role: string
    createdAt: DateTime
    
  ApiKey = object
    id: string
    userId: string
    key: string
    name: string
    createdAt: DateTime
    expiresAt: Option[DateTime]
    
  LibraryDoc = object
    library: Library
    content: string
    createdBy: string
    createdAt: DateTime

# Global state
var
  config: Config
  db: DbConn
  redisConn: Redis

# Load configuration
proc loadConfig(): Config =
  result = Config(
    host: getEnv("HOST", "0.0.0.0"),
    port: parseInt(getEnv("PORT", "8000")),
    dbHost: getEnv("DB_HOST", "localhost"),
    dbPort: parseInt(getEnv("DB_PORT", "5432")),
    dbName: getEnv("DB_NAME", "context7"),
    dbUser: getEnv("DB_USER", "context7"),
    dbPass: getEnv("DB_PASS", "context7pass"),
    redisHost: getEnv("REDIS_HOST", "localhost"),
    redisPort: parseInt(getEnv("REDIS_PORT", "6379")),
    jwtSecret: getEnv("JWT_SECRET", "change-me-in-production"),
    corsOrigins: @["http://localhost:3000", "https://context7.com"]
  )

# Database initialization
proc initDatabase() =
  db = open(config.dbHost, config.dbUser, config.dbPass, config.dbName)
  
  # Create tables
  db.exec(sql"""
    CREATE TABLE IF NOT EXISTS users (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      email VARCHAR(255) UNIQUE NOT NULL,
      password_hash VARCHAR(255) NOT NULL,
      organization VARCHAR(100) NOT NULL,
      role VARCHAR(50) DEFAULT 'user',
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  """)
  
  db.exec(sql"""
    CREATE TABLE IF NOT EXISTS api_keys (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id UUID REFERENCES users(id) ON DELETE CASCADE,
      key VARCHAR(255) UNIQUE NOT NULL,
      name VARCHAR(100) NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      expires_at TIMESTAMP
    )
  """)
  
  db.exec(sql"""
    CREATE TABLE IF NOT EXISTS libraries (
      id VARCHAR(255) PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      version VARCHAR(50) NOT NULL,
      description TEXT,
      tags TEXT[],
      trust_score INTEGER DEFAULT 5,
      snippet_count INTEGER DEFAULT 0,
      organization VARCHAR(100) NOT NULL,
      content TEXT NOT NULL,
      created_by UUID REFERENCES users(id),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      UNIQUE(organization, name, version)
    )
  """)
  
  db.exec(sql"""
    CREATE INDEX IF NOT EXISTS idx_libraries_org ON libraries(organization);
    CREATE INDEX IF NOT EXISTS idx_libraries_name ON libraries(name);
    CREATE INDEX IF NOT EXISTS idx_libraries_search ON libraries USING gin(to_tsvector('english', name || ' ' || description));
  """)

# Redis initialization
proc initRedis() =
  redisConn = open(config.redisHost, config.redisPort.Port)

# JWT utilities
proc generateToken(userId: string, email: string, org: string): string =
  var claims = initTable[string, string]()
  claims["user_id"] = userId
  claims["email"] = email
  claims["org"] = org
  claims["exp"] = $(epochTime() + 86400)  # 24 hours
  
  result = toJWT(claims, config.jwtSecret)

proc verifyToken(token: string): Option[Table[string, string]] =
  try:
    let claims = fromJWT[Table[string, string]](token, config.jwtSecret)
    if parseFloat(claims["exp"]) > epochTime():
      result = some(claims)
  except:
    result = none(Table[string, string])

# Middleware
proc corsMiddleware(request: Request, response: Response) {.async.} =
  let origin = request.headers.getOrDefault("Origin")
  if origin in config.corsOrigins:
    response.headers["Access-Control-Allow-Origin"] = origin
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
    response.headers["Access-Control-Allow-Credentials"] = "true"

proc authMiddleware(request: Request): Option[Table[string, string]] =
  let authHeader = request.headers.getOrDefault("Authorization")
  if authHeader.startsWith("Bearer "):
    let token = authHeader[7..^1]
    result = verifyToken(token)
  else:
    result = none(Table[string, string])

# API Routes
router api:
  # CORS preflight
  options "*":
    resp(Http200, "")
  
  # Health check
  get "/health":
    resp %*{"status": "ok", "timestamp": $now()}
  
  # Authentication
  post "/auth/register":
    let body = parseJson(request.body)
    let email = body["email"].getStr()
    let password = body["password"].getStr()
    let organization = body["organization"].getStr()
    
    if not isValidOrgName(organization):
      resp(Http400, %*{"error": "Invalid organization name"})
      return
    
    let passwordHash = hashPw(password, genSalt(10))
    let userId = $genUUID()
    
    try:
      db.exec(sql"""
        INSERT INTO users (id, email, password_hash, organization)
        VALUES (?, ?, ?, ?)
      """, userId, email, passwordHash, organization)
      
      let token = generateToken(userId, email, organization)
      resp %*{
        "token": token,
        "user": {
          "id": userId,
          "email": email,
          "organization": organization
        }
      }
    except:
      resp(Http400, %*{"error": "Email already exists"})
  
  post "/auth/login":
    let body = parseJson(request.body)
    let email = body["email"].getStr()
    let password = body["password"].getStr()
    
    let row = db.getRow(sql"""
      SELECT id, password_hash, organization FROM users WHERE email = ?
    """, email)
    
    if row[0] == "":
      resp(Http401, %*{"error": "Invalid credentials"})
      return
    
    if not checkPw(password, row[1]):
      resp(Http401, %*{"error": "Invalid credentials"})
      return
    
    let token = generateToken(row[0], email, row[2])
    resp %*{
      "token": token,
      "user": {
        "id": row[0],
        "email": email,
        "organization": row[2]
      }
    }
  
  # Libraries API
  get "/api/libraries":
    let auth = authMiddleware(request)
    if auth.isNone:
      resp(Http401, %*{"error": "Unauthorized"})
      return
    
    let query = request.params.getOrDefault("q", "")
    let page = parseInt(request.params.getOrDefault("page", "1"))
    let pageSize = parseInt(request.params.getOrDefault("pageSize", "20"))
    let offset = (page - 1) * pageSize
    
    var libraries = newSeq[Library]()
    var totalCount = 0
    
    if query.len > 0:
      # Full-text search
      let rows = db.getAllRows(sql"""
        SELECT id, name, version, description, tags, trust_score, snippet_count, organization, last_updated
        FROM libraries
        WHERE to_tsvector('english', name || ' ' || description) @@ plainto_tsquery('english', ?)
        ORDER BY trust_score DESC, snippet_count DESC
        LIMIT ? OFFSET ?
      """, query, pageSize, offset)
      
      for row in rows:
        libraries.add(Library(
          id: row[0],
          name: row[1],
          version: row[2],
          description: row[3],
          tags: if row[4] != "": row[4].split(",") else: @[],
          trustScore: parseInt(row[5]),
          snippetCount: parseInt(row[6]),
          organization: row[7],
          lastUpdated: row[8]
        ))
      
      totalCount = parseInt(db.getValue(sql"""
        SELECT COUNT(*) FROM libraries
        WHERE to_tsvector('english', name || ' ' || description) @@ plainto_tsquery('english', ?)
      """, query))
    else:
      # List all
      let rows = db.getAllRows(sql"""
        SELECT id, name, version, description, tags, trust_score, snippet_count, organization, last_updated
        FROM libraries
        ORDER BY last_updated DESC
        LIMIT ? OFFSET ?
      """, pageSize, offset)
      
      for row in rows:
        libraries.add(Library(
          id: row[0],
          name: row[1],
          version: row[2],
          description: row[3],
          tags: if row[4] != "": row[4].split(",") else: @[],
          trustScore: parseInt(row[5]),
          snippetCount: parseInt(row[6]),
          organization: row[7],
          lastUpdated: row[8]
        ))
      
      totalCount = parseInt(db.getValue(sql"SELECT COUNT(*) FROM libraries"))
    
    resp %*{
      "libraries": libraries,
      "totalCount": totalCount,
      "page": page,
      "pageSize": pageSize
    }
  
  post "/api/libraries":
    let auth = authMiddleware(request)
    if auth.isNone:
      resp(Http401, %*{"error": "Unauthorized"})
      return
    
    let body = parseJson(request.body)
    let name = body["name"].getStr()
    let version = body["version"].getStr()
    let description = body["description"].getStr()
    let tags = body["tags"].getElems().mapIt(it.getStr())
    let content = body["content"].getStr()
    
    if not isValidLibraryName(name):
      resp(Http400, %*{"error": "Invalid library name"})
      return
    
    if not isValidVersion(version):
      resp(Http400, %*{"error": "Invalid version format"})
      return
    
    let userId = auth.get()["user_id"]
    let org = auth.get()["org"]
    let libraryId = generateLibraryId(org, name, version)
    
    try:
      db.exec(sql"""
        INSERT INTO libraries (id, name, version, description, tags, organization, content, created_by)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      """, libraryId, name, version, description, tags.join(","), org, content, userId)
      
      # Invalidate cache
      discard redisConn.del("libraries:" & org)
      
      resp(Http201, %*{
        "id": libraryId,
        "name": name,
        "version": version,
        "organization": org
      })
    except:
      resp(Http400, %*{"error": "Library already exists"})
  
  get "/api/libraries/@id":
    let auth = authMiddleware(request)
    if auth.isNone:
      resp(Http401, %*{"error": "Unauthorized"})
      return
    
    let libraryId = @"id"
    
    # Check cache first
    let cached = redisConn.get("library:" & libraryId)
    if cached != redisNil:
      resp cached
      return
    
    let row = db.getRow(sql"""
      SELECT id, name, version, description, tags, trust_score, snippet_count, organization, content, last_updated
      FROM libraries
      WHERE id = ?
    """, libraryId)
    
    if row[0] == "":
      resp(Http404, %*{"error": "Library not found"})
      return
    
    let response = %*{
      "library": {
        "id": row[0],
        "name": row[1],
        "version": row[2],
        "description": row[3],
        "tags": if row[4] != "": row[4].split(",") else: @[],
        "trustScore": parseInt(row[5]),
        "snippetCount": parseInt(row[6]),
        "organization": row[7],
        "lastUpdated": row[9]
      },
      "content": row[8]
    }
    
    # Cache for 1 hour
    discard redisConn.setex("library:" & libraryId, 3600, $response)
    
    resp response

# Main
when isMainModule:
  config = loadConfig()
  initDatabase()
  initRedis()
  
  info "Starting Context7 SaaS server", host = config.host, port = config.port
  
  let settings = newSettings(port = Port(config.port), bindAddr = config.host)
  var jester = initJester(api, settings = settings)
  jester.serve()