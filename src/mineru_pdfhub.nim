##[
  MinerU-PDFHub - On-premises MCP server for private library documentation
  
  This server provides MCP (Model Context Protocol) interface for managing
  and serving documentation of private/internal libraries.
  
  Enhanced with HTTP and SSE transport mode support.
  
  MinerU-PDFHub 主程序：负责启动 MCP 服务器、选择传输模式并协调 Git/备份/权限等扩展功能。
]##

import std/[asyncdispatch, asyncnet, asynchttpserver, json, strutils, os, logging, options, tables, random, nativesockets, sequtils]
import nimcp
import library_manager, config_manager, cli, mcp_tools, mcp_helpers, ui_assets, git_manager, git_sync, access_manager, backup_manager

const VERSION = "1.0.0"

# Global库管理器及 Git 管理器使用线程局部存储以满足 GC 安全检查
var g_library_manager {.threadvar.}: LibraryManager
var g_git_manager {.threadvar.}: GitManager
var g_access_manager {.threadvar.}: AccessManager
var g_backup_manager {.threadvar.}: BackupManager

# Create the MCP server using the macro API with simple, GC-safe operations
let server = mcpServer("mineru-pdfhub", VERSION):
  
  mcpTool:
    proc register_library(name: string, version: string, docs: string, description: string = ""): JsonNode {.gcsafe.} =
      ## Register a new library with documentation
      ## - name: Library name
      ## - version: Library version
      ## - docs: Documentation content
      ## - description: Library description (optional)
      return handleRegisterLibrary(name, version, docs, description)
  
  mcpTool:
    proc search_libraries(query: string): JsonNode {.gcsafe.} =
      ## Search for libraries by name or description
      ## - query: Search query
      return handleSearchLibraries(query)
  
  mcpTool:
    proc get_library_docs(name: string, version: string = "latest", max_characters: int = 5000, topic: string = "", topic_match: string = "literal"): JsonNode {.gcsafe.} =
      ## Get documentation for a specific library
      ## - name: Library name
      ## - version: Library version (default: latest)
      ## - max_characters: Maximum number of characters to return (default: 5000)
      ## - topic: Optional comma-separated list of up to 5 topic keywords (highest priority first)
      ## - topic_match: Optional knowledge-graph matching algorithm (literal, structure, embedding)
      return handleGetLibraryDocs(name, version, max_characters, topic, topic_match)

type
  SseClient* = ref SseClientObj
  SseState = ref object
    clients: Table[string, SseClient]
  SseClientObj = object
    sessionId: string
    socket: AsyncSocket
    closed: bool
    lastSend: Future[void]
    state: SseState

const SupportedTools = @["register_library", "search_libraries", "get_library_docs"]

var
  httpServerInstance: AsyncHttpServer
  sseServerInstance: AsyncHttpServer
  sseState = SseState(clients: initTable[string, SseClient]())

proc stopHttpServer*() =
  ## Stop the active HTTP server (used in tests)
  if httpServerInstance != nil:
    httpServerInstance.close()
    httpServerInstance = nil

## 检查当前配置是否需要进行认证，支持 API Key 与多用户模式两种入口
proc authRequired(config: Config): bool =
  if config.security.enableAuth and config.security.apiKeys.len > 0:
    return true
  if not g_access_manager.isNil and g_access_manager.users.len > 0:
    return true
  config.access.multiUserEnabled

## 校验 HTTP/SSE 请求头中的 Bearer Token，结合多用户存储返回令牌详情
proc checkAuthorization(headers: HttpHeaders, config: Config): tuple[ok: bool, message: string, token: string, user: Option[UserAccount]] {.gcsafe.} =
  if not authRequired(config):
    return (true, "", "", none(UserAccount))
  if not headers.hasKey("Authorization"):
    return (false, "Missing Authorization header", "", none(UserAccount))
  let headerValue = headers["Authorization"]
  if not headerValue.startsWith("Bearer "):
    return (false, "Authorization header must use Bearer scheme", "", none(UserAccount))
  let token = headerValue[7 .. ^1].strip()
  if token.len == 0:
    return (false, "Bearer token is empty", "", none(UserAccount))

  if not g_access_manager.isNil and (config.access.multiUserEnabled or g_access_manager.users.len > 0):
    let userOpt = g_access_manager.getUserByToken(token)
    if userOpt.isSome():
      let user = userOpt.get()
      if user.active:
        return (true, "", token, userOpt)
      return (false, "User token inactive", token, none(UserAccount))
    return (false, "Invalid bearer token", token, none(UserAccount))

  for allowed in config.security.apiKeys:
    if token == allowed:
      return (true, "", token, none(UserAccount))
  (false, "Invalid bearer token", token, none(UserAccount))

## 根据工具名推断调用所需的权限标识
proc requiredPermission(toolName: string): string {.gcsafe.} =
  case toolName
  of "register_library":
    "write"
  of "search_libraries", "get_library_docs":
    "read"
  else:
    "read"

## 判断指定令牌是否具备给定权限；未启用多用户模式时默认放行
proc hasPermission(config: Config, token: string, permission: string): bool {.gcsafe.} =
  if not config.access.multiUserEnabled or g_access_manager.isNil:
    return true
  if token.len == 0:
    return false
  g_access_manager.userHasPermission(token, permission)

## 若开启库范围限制，则验证该令牌是否被授权访问目标库
proc libraryScopeAllowed(config: Config, token: string, libraryName: string): bool {.gcsafe.} =
  if not config.access.multiUserEnabled or not config.access.enforceLibraryScope or g_access_manager.isNil:
    return true
  if libraryName.len == 0:
    return true
  g_access_manager.userAllowedForLibrary(token, libraryName)

## 在执行 MCP 工具前执行权限与库范围检查，返回违规原因（若存在）
proc checkToolAccess(config: Config, token: string, params: JsonNode): Option[string] {.gcsafe.} =
  if not config.access.multiUserEnabled or g_access_manager.isNil:
    return none(string)
  if token.len == 0:
    return some("Missing authentication token")
  if params.isNil or params.kind != JObject:
    return some("Invalid parameters payload")
  if not params.hasKey("toolName") or params["toolName"].kind != JString:
    return some("Missing toolName parameter")
  let toolName = params["toolName"].getStr()
  let permission = requiredPermission(toolName)
  if not hasPermission(config, token, permission):
    return some("Permission '" & permission & "' required for tool " & toolName)
  if params.hasKey("arguments") and params["arguments"].kind == JObject:
    let argsNode = params["arguments"]
    if argsNode.hasKey("name") and argsNode["name"].kind == JString:
      let libraryName = argsNode["name"].getStr()
      if not libraryScopeAllowed(config, token, libraryName):
        return some("Access denied for library: " & libraryName)
  none(string)

proc buildUiSuccess(message: string, data: JsonNode = nil): JsonNode {.gcsafe.} =
  var result = createToolSuccessResult(message)
  if data != nil:
    result["data"] = data
  result

proc buildUiError(message: string): JsonNode {.gcsafe.} =
  createToolErrorResult(message)

proc adminPermission(toolName: string): string {.gcsafe.} =
  case toolName
  of "library_export": "read"
  of "library_import": "write"
  of "backup_list", "backup_create", "backup_restore", "backup_prune": "backup"
  of "git_list", "git_add", "git_remove", "git_sync": "git.sync"
  of "users_list", "roles_list": "admin"
  of "users_add", "users_remove", "users_deactivate", "users_activate", "roles_add", "roles_remove": "admin"
  else:
    ""

proc ensureGitManager(config: Config): bool =
  if g_git_manager.isNil:
    try:
      g_git_manager = newGitManager(config.integration)
    except CatchableError:
      return false
  true

proc ensureAccessManager(config: Config): bool =
  if g_access_manager.isNil:
    try:
      g_access_manager = newAccessManager(config.access)
    except CatchableError:
      return false
  true

proc ensureBackupManager(config: Config): bool =
  let dataDir = config.storage.dataDir
  if g_backup_manager.isNil or g_backup_manager.dataDir != dataDir or g_backup_manager.config != config.backup:
    try:
      g_backup_manager = newBackupManager(config.backup, dataDir)
    except CatchableError:
      g_backup_manager = nil
      return false
  else:
    g_backup_manager.config = config.backup
    g_backup_manager.dataDir = dataDir
  true

proc getBackupManager(config: Config): BackupManager {.gcsafe.} =
  if not ensureBackupManager(config):
    raise newException(IOError, "Backup manager initialization failed")
  g_backup_manager

proc gitSyncResultToJson(res: GitSyncResult): JsonNode {.gcsafe.} =
  %*{
    "repoId": res.repoId,
    "libraryName": res.libraryName,
    "updated": res.updated,
    "commit": res.commit,
    "message": res.message,
    "error": res.error
  }

proc permissionsToJson(perms: seq[string]): JsonNode =
  result = newJArray()
  for perm in perms:
    result.add(%perm)

proc userInfoToJson(manager: AccessManager, user: UserAccount, includeToken = false): JsonNode {.gcsafe.} =
  let perms =
    if not manager.isNil and user.role in manager.roles:
      manager.roles[user.role].permissions
    else:
      @[]
  let isAdmin =
    if manager.isNil:
      false
    else:
      manager.roleHasPermission(user.role, "*")
  var node = %*{
    "username": user.username,
    "role": user.role,
    "libraries": user.libraries,
    "active": user.active,
    "permissions": permissionsToJson(perms),
    "isAdmin": isAdmin
  }
  if includeToken:
    node["token"] = %user.token
  node

proc usersToJson(manager: AccessManager): JsonNode {.gcsafe.} =
  var arr = newJArray()
  for _, user in manager.users:
    arr.add(userInfoToJson(manager, user, includeToken = true))
  %*{ "users": arr }

proc rolesToJson(manager: AccessManager): JsonNode {.gcsafe.} =
  var arr = newJArray()
  for _, role in manager.roles:
    arr.add(%*{
      "name": role.name,
      "permissions": role.permissions
    })
  %*{ "roles": arr }

proc handleAdminAction(toolName: string, args: JsonNode, token: string, config: Config): Future[JsonNode] {.async.} =
  let action = toolName.toLowerAscii()
  let permission = adminPermission(action)
  if permission.len > 0 and not hasPermission(config, token, permission):
    return buildUiError("Permission '" & permission & "' required")

  try:
    case action
    of "library_export":
      if not args.hasKey("name") or args["name"].kind != JString:
        return buildUiError("Missing 'name' field")
      let name = args["name"].getStr()
      let version =
        if args.hasKey("version") and args["version"].kind == JString and args["version"].getStr().len > 0:
          args["version"].getStr()
        else:
          "latest"
      let libOpt = await g_library_manager.getLibrary(name, version)
      if libOpt.isNone():
        return buildUiError("Library not found: " & name & "@" & version)
      let lib = libOpt.get()
      var data = newJObject()
      data["library"] = libraryToJson(lib)
      data["fileName"] = %(lib.name & "@" & lib.version & ".json")
      return buildUiSuccess("Exported library " & lib.name & "@" & lib.version, data)

    of "library_import":
      if not args.hasKey("library"):
        return buildUiError("Missing 'library' payload")
      var libraryNode = args["library"]
      if libraryNode.kind == JString:
        libraryNode = parseJson(libraryNode.getStr())
      if libraryNode.kind != JObject:
        return buildUiError("'library' must be a JSON object")
      var imported = g_library_manager.libraryFromJson(libraryNode)
      await g_library_manager.registerLibrary(imported)
      let data = %*{"library": libraryToJson(imported)}
      return buildUiSuccess("Imported library " & imported.name & "@" & imported.version, data)

    of "backup_list":
      let backupMgr = getBackupManager(config)
      backupMgr.refresh()
      var arr = newJArray()
      for snapshot in backupMgr.listSnapshots():
        arr.add(snapshotToJson(snapshot))
      return buildUiSuccess("Retrieved " & $arr.len & " backup snapshots", %*{"snapshots": arr})

    of "backup_create":
      let backupMgr = getBackupManager(config)
      backupMgr.refresh()
      let note = if args.hasKey("note") and args["note"].kind == JString: args["note"].getStr() else: ""
      let snapshot = backupMgr.createSnapshot(note)
      return buildUiSuccess("Created backup " & snapshot.id, %*{"snapshot": snapshotToJson(snapshot)})

    of "backup_restore":
      if not args.hasKey("snapshotId") or args["snapshotId"].kind != JString:
        return buildUiError("Missing 'snapshotId' field")
      let snapshotId = args["snapshotId"].getStr()
      let backupMgr = getBackupManager(config)
      backupMgr.refresh()
      backupMgr.restoreSnapshot(snapshotId)
      g_library_manager = newLibraryManager(config.storage.dataDir)
      setGlobalLibraryManager(g_library_manager)
      if ensureGitManager(config):
        try:
          g_git_manager.refresh()
        except CatchableError as e:
          echo "[warn] Failed to refresh Git repositories after restore: " & e.msg
      return buildUiSuccess("Restored backup " & snapshotId)

    of "backup_prune":
      let backupMgr = getBackupManager(config)
      backupMgr.refresh()
      backupMgr.pruneExpiredSnapshots()
      var arr = newJArray()
      for snapshot in backupMgr.listSnapshots():
        arr.add(snapshotToJson(snapshot))
      return buildUiSuccess("Pruned expired backups", %*{"snapshots": arr})

    of "git_list":
      if not ensureGitManager(config):
        return buildUiError("Git integration not available")
      var arr = newJArray()
      for repo in g_git_manager.listRepos():
        arr.add(descriptorToJson(repo))
      return buildUiSuccess("Loaded " & $arr.len & " Git repositories", %*{"repositories": arr})

    of "git_add":
      if not ensureGitManager(config):
        return buildUiError("Git integration not available")
      if not args.hasKey("url") or args["url"].kind != JString:
        return buildUiError("Missing 'url' field")
      if not args.hasKey("docsPath") or args["docsPath"].kind != JString:
        return buildUiError("Missing 'docsPath' field")
      var descriptor = GitRepoDescriptor(
        id: if args.hasKey("id") and args["id"].kind == JString: args["id"].getStr() else: "",
        name: if args.hasKey("name") and args["name"].kind == JString: args["name"].getStr() else: "",
        url: args["url"].getStr(),
        branch: if args.hasKey("branch") and args["branch"].kind == JString: args["branch"].getStr() else: config.integration.defaultBranch,
        docsPath: args["docsPath"].getStr(),
        libraryName: if args.hasKey("library") and args["library"].kind == JString: args["library"].getStr() else: "",
        version: if args.hasKey("version") and args["version"].kind == JString: args["version"].getStr() else: "latest",
        autoSync: if args.hasKey("autoSync") and args["autoSync"].kind in {JBool, JInt}: args["autoSync"].getBool() else: true
      )
      g_git_manager.addOrUpdateRepo(descriptor)
      g_git_manager.refresh()
      let repo = g_git_manager.repos[descriptor.id]
      return buildUiSuccess("Saved Git repo " & repo.id, %*{"repository": descriptorToJson(repo)})

    of "git_remove":
      if not ensureGitManager(config):
        return buildUiError("Git integration not available")
      if not args.hasKey("id") or args["id"].kind != JString:
        return buildUiError("Missing 'id' field")
      let repoId = args["id"].getStr()
      if g_git_manager.removeRepo(repoId):
        return buildUiSuccess("Removed Git repo " & repoId)
      else:
        return buildUiError("Repository not found: " & repoId)

    of "git_sync":
      if not ensureGitManager(config):
        return buildUiError("Git integration not available")
      let storageDir = config.storage.dataDir
      if args.hasKey("id") and args["id"].kind == JString and args["id"].getStr().len > 0:
        let repoId = args["id"].getStr()
        let res = await g_git_manager.syncRepository(g_library_manager, storageDir, repoId)
        if res.error:
          return buildUiError(res.message)
        return buildUiSuccess(res.message, %*{"result": gitSyncResultToJson(res)})
      else:
        let results = await g_git_manager.syncAll(g_library_manager, storageDir)
        var arr = newJArray()
        for r in results:
          arr.add(gitSyncResultToJson(r))
        return buildUiSuccess("Sync complete for " & $arr.len & " repositories", %*{"results": arr})

    of "users_list":
      if not ensureAccessManager(config):
        return buildUiError("Access manager not available")
      return buildUiSuccess("Loaded users", usersToJson(g_access_manager))

    of "roles_list":
      if not ensureAccessManager(config):
        return buildUiError("Access manager not available")
      return buildUiSuccess("Loaded roles", rolesToJson(g_access_manager))

    of "users_add":
      if not ensureAccessManager(config):
        return buildUiError("Access manager not available")
      if not args.hasKey("username") or args["username"].kind != JString:
        return buildUiError("Missing 'username' field")
      let usernameValue = args["username"].getStr().strip()
      if usernameValue.len == 0:
        return buildUiError("Username cannot be empty")

      var libraries: seq[string] = @[]
      var librariesProvided = false
      if args.hasKey("libraries"):
        librariesProvided = true
        let libsNode = args["libraries"]
        case libsNode.kind
        of JArray:
          for item in libsNode:
            if item.kind == JString:
              let value = item.getStr().strip()
              if value.len > 0:
                libraries.add(value)
        of JString:
          for part in libsNode.getStr().split(','):
            let value = part.strip()
            if value.len > 0:
              libraries.add(value)
        else:
          discard

      var activeProvided = false
      var activeValue = true
      if args.hasKey("active") and args["active"].kind in {JBool, JInt}:
        activeProvided = true
        activeValue = args["active"].getBool()

      let roleValue = if args.hasKey("role") and args["role"].kind == JString: args["role"].getStr() else: ""

      var passwordProvided = false
      var passwordValue = ""
      if args.hasKey("password"):
        if args["password"].kind != JString:
          return buildUiError("'password' must be a string")
        passwordValue = args["password"].getStr()
        passwordProvided = true
        if passwordValue.len == 0:
          return buildUiError("Password cannot be empty")

      let rotateToken = if args.hasKey("rotateToken") and args["rotateToken"].kind in {JBool, JInt}: args["rotateToken"].getBool() else: false

      let userOpt = g_access_manager.getUserByName(usernameValue)
      if userOpt.isSome():
        let current = userOpt.get()
        let effectiveRole = if roleValue.len > 0: roleValue else: current.role
        let effectiveLibraries = if librariesProvided: libraries else: current.libraries
        let effectiveActive = if activeProvided: activeValue else: current.active
        let passwordOpt = if passwordProvided: some(passwordValue) else: none(string)
        let updated = g_access_manager.updateUser(
          usernameValue,
          effectiveRole,
          effectiveLibraries,
          effectiveActive,
          passwordOpt,
          rotateToken
        )
        return buildUiSuccess("Updated user " & usernameValue, %*{
          "user": userInfoToJson(g_access_manager, updated, includeToken = true)
        })
      else:
        if not passwordProvided:
          return buildUiError("Password is required when creating a user")
        var created = g_access_manager.registerUser(
          usernameValue,
          passwordValue,
          roleValue,
          if librariesProvided: libraries else: @[]
        )
        if activeProvided and not activeValue:
          created = g_access_manager.updateUser(usernameValue, created.role, created.libraries, false)
        return buildUiSuccess("Created user " & usernameValue, %*{
          "user": userInfoToJson(g_access_manager, created, includeToken = true)
        })

    of "users_deactivate":
      if not ensureAccessManager(config):
        return buildUiError("Access manager not available")
      if not args.hasKey("username") or args["username"].kind != JString:
        return buildUiError("Missing 'username' field")
      let usernameValue = args["username"].getStr().strip()
      if usernameValue.len == 0:
        return buildUiError("Username cannot be empty")
      let userOpt = g_access_manager.getUserByName(usernameValue)
      if userOpt.isNone():
        return buildUiError("User not found")
      let current = userOpt.get()
      let updated = g_access_manager.updateUser(usernameValue, current.role, current.libraries, false)
      return buildUiSuccess("Deactivated user " & usernameValue, %*{
        "user": userInfoToJson(g_access_manager, updated, includeToken = true)
      })

    of "users_activate":
      if not ensureAccessManager(config):
        return buildUiError("Access manager not available")
      if not args.hasKey("username") or args["username"].kind != JString:
        return buildUiError("Missing 'username' field")
      let usernameValue = args["username"].getStr().strip()
      if usernameValue.len == 0:
        return buildUiError("Username cannot be empty")
      let userOpt = g_access_manager.getUserByName(usernameValue)
      if userOpt.isNone():
        return buildUiError("User not found")
      let current = userOpt.get()
      let updated = g_access_manager.updateUser(usernameValue, current.role, current.libraries, true)
      return buildUiSuccess("Activated user " & usernameValue, %*{
        "user": userInfoToJson(g_access_manager, updated, includeToken = true)
      })

    of "users_remove":
      if not ensureAccessManager(config):
        return buildUiError("Access manager not available")
      if not args.hasKey("username") or args["username"].kind != JString:
        return buildUiError("Missing 'username' field")
      let usernameValue = args["username"].getStr().strip()
      if usernameValue.len == 0:
        return buildUiError("Username cannot be empty")
      let userOpt = g_access_manager.getUserByName(usernameValue)
      if userOpt.isNone():
        return buildUiError("User not found")
      let tokenValue = userOpt.get().token
      if tokenValue.len == 0 or not g_access_manager.removeUser(tokenValue):
        return buildUiError("User removal failed")
      return buildUiSuccess("Removed user " & usernameValue)

    of "roles_add":
      if not ensureAccessManager(config):
        return buildUiError("Access manager not available")
      if not args.hasKey("name") or args["name"].kind != JString:
        return buildUiError("Missing 'name' field")
      let name = args["name"].getStr()
      var permissions: seq[string] = @[]
      if args.hasKey("permissions"):
        let permsNode = args["permissions"]
        case permsNode.kind
        of JArray:
          for item in permsNode:
            if item.kind == JString:
              let value = item.getStr().strip()
              if value.len > 0:
                permissions.add(value)
        of JString:
          for part in permsNode.getStr().split(','):
            let value = part.strip()
            if value.len > 0:
              permissions.add(value)
        else:
          discard
      if permissions.len == 0:
        return buildUiError("Permissions cannot be empty")
      g_access_manager.addOrUpdateRole(RoleDefinition(name: name, permissions: permissions))
      return buildUiSuccess("Saved role " & name, %*{"role": %*{"name": name, "permissions": permissions}})

    of "roles_remove":
      if not ensureAccessManager(config):
        return buildUiError("Access manager not available")
      if not args.hasKey("name") or args["name"].kind != JString:
        return buildUiError("Missing 'name' field")
      let name = args["name"].getStr()
      if g_access_manager.removeRole(name):
        return buildUiSuccess("Removed role " & name)
      else:
        return buildUiError("Role not found: " & name)

    else:
      return buildUiError("Unknown admin action: " & toolName)
  except CatchableError as e:
    return buildUiError(e.msg)

## 向客户端返回 JSON 响应并补齐跨域头，适用于 HTTP/SSE 接口
proc respondJson(req: Request, status: HttpCode, payload: JsonNode) {.async.} =
  var headers = newHttpHeaders()
  headers["Content-Type"] = "application/json"
  headers["Access-Control-Allow-Origin"] = "*"
  headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type"
  await req.respond(status, $payload, headers)

## 返回纯文本响应（带 UTF-8 编码声明）
proc respondPlain(req: Request, status: HttpCode, message: string) {.async.} =
  var headers = newHttpHeaders()
  headers["Content-Type"] = "text/plain; charset=utf-8"
  headers["Access-Control-Allow-Origin"] = "*"
  headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type"
  await req.respond(status, message, headers)

## 用于内置 UI 的 HTML 响应输出
proc respondHtml(req: Request, status: HttpCode, content: string) {.async.} =
  var headers = newHttpHeaders()
  headers["Content-Type"] = "text/html; charset=utf-8"
  headers["Access-Control-Allow-Origin"] = "*"
  headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type"
  await req.respond(status, content, headers)

## 统一处理 401 场景，返回结构化错误消息
proc respondUnauthorized(req: Request, message: string) {.async.} =
  await respondJson(req, Http401, %*{"error": message})

## 处理参数或载荷错误，快速返回 400
proc respondBadRequest(req: Request, message: string) {.async.} =
  await respondJson(req, Http400, %*{"error": message})

## 处理预检请求并声明允许的方法及请求头
proc respondCors(req: Request, allowedMethods: string) {.async.} =
  var headers = newHttpHeaders()
  headers["Access-Control-Allow-Origin"] = "*"
  headers["Access-Control-Allow-Methods"] = allowedMethods
  headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type"
  headers["Access-Control-Max-Age"] = "86400"
  await req.respond(Http204, "", headers)

proc dispatchTool(toolName: string, args: JsonNode): JsonNode =
  case toolName
  of "register_library":
    if not args.hasKey("name") or not args.hasKey("version") or not args.hasKey("docs"):
      return createToolErrorResult("Missing required arguments for register_library: name, version, docs")
    let name = args["name"].getStr()
    let version = args["version"].getStr()
    let docs = args["docs"].getStr()
    let description = if args.hasKey("description"): args["description"].getStr() else: ""
    return handleRegisterLibrary(name, version, docs, description)
  of "search_libraries":
    if not args.hasKey("query"):
      return createToolErrorResult("Missing required argument for search_libraries: query")
    let query = args["query"].getStr()
    return handleSearchLibraries(query)
  of "get_library_docs":
    if not args.hasKey("name"):
      return createToolErrorResult("Missing required argument for get_library_docs: name")
    let name = args["name"].getStr()
    let version = if args.hasKey("version"): args["version"].getStr() else: "latest"
    let maxChars = if args.hasKey("max_characters"): args["max_characters"].getInt() else: 5000
    let topic = if args.hasKey("topic"): args["topic"].getStr() else: ""
    let topicMatch = if args.hasKey("topic_match"): args["topic_match"].getStr() else: "literal"
    return handleGetLibraryDocs(name, version, maxChars, topic, topicMatch)
  else:
    return createToolErrorResult("Unknown tool: " & toolName)

## 生成 16 位会话 ID，用于 SSE 连接标识
proc generateSessionId(): string =
  const alphabet = "abcdefghijklmnopqrstuvwxyz0123456789"
  result = newStringOfCap(16)
  for _ in 0 ..< 16:
    result.add(alphabet[rand(alphabet.len - 1)])

## 从 SSE 客户端字典中移除指定会话并关闭连接
proc removeSseClient(state: SseState, sessionId: string) {.gcsafe.} =
  if sessionId in state.clients:
    let client = state.clients[sessionId]
    client.closed = true
    try:
      client.socket.close()
    except:
      discard
    state.clients.del(sessionId)

proc stopSseServer*() =
  ## Stop the active SSE server and close all client connections (used in tests)
  if sseServerInstance != nil:
    sseServerInstance.close()
    sseServerInstance = nil
  let keys = sseState.clients.keys.toSeq()
  for sessionId in keys:
    removeSseClient(sseState, sessionId)

## 将 SSE 数据写入客户端 socket，包含错误恢复逻辑
proc sendSsePayload(client: SseClient, payload: string) {.async, gcsafe.} =
  if client.closed:
    return
  if client.lastSend != nil and not client.lastSend.finished:
    try:
      await client.lastSend
    except:
      client.closed = true
      removeSseClient(client.state, client.sessionId)
      return
  let sendFuture = client.socket.send(payload)
  client.lastSend = sendFuture
  try:
    await sendFuture
  except:
    client.closed = true
    removeSseClient(client.state, client.sessionId)

## 将多行数据转换为符合 SSE 规范的输出格式
proc formatSseData(data: string): string {.gcsafe.} =
  let lines = data.splitLines()
  if lines.len == 0:
    return "data: \n"
  result = ""
  for line in lines:
    result.add("data: " & line & "\n")

proc sendSseEvent(client: SseClient, eventName: string, data: string) {.async, gcsafe.} =
  if client.closed:
    return
  var payload = ""
  if eventName.len > 0:
    payload.add("event: " & eventName & "\n")
  payload.add(formatSseData(data))
  payload.add("\n")
  await sendSsePayload(client, payload)

proc sendSseJson(client: SseClient, eventName: string, node: JsonNode) {.async, gcsafe.} =
  await sendSseEvent(client, eventName, $node)

proc sendSseComment(client: SseClient, comment: string) {.async, gcsafe.} =
  if client.closed:
    return
  await sendSsePayload(client, ": " & comment & "\n\n")

proc startSseKeepAlive(client: SseClient, sessionId: string) {.async, gcsafe.} =
  while not client.closed:
    await sleepAsync(15000)
    if client.closed:
      break
    try:
      await sendSseComment(client, "keepalive")
    except:
      break
  removeSseClient(client.state, sessionId)
proc serveWithStdio() {.async.} =
  ## Serve using stdio transport (default)
  info "Starting MinerU-PDFHub MCP Server with stdio transport"
  let transport = newStdioTransport()
  transport.serve(server)

proc jsonRpcIdToJson(id: JsonRpcId): JsonNode =
  case id.kind
  of jridString:
    result = newJString(id.str)
  of jridInt:
    result = %id.num

proc jsonRpcResponseToJson(response: JsonRpcResponse): JsonNode =
  result = newJObject()
  result["jsonrpc"] = %"2.0"
  result["id"] = jsonRpcIdToJson(response.id)
  if response.result.isSome:
    result["result"] = response.result.get
  if response.error.isSome:
    let err = response.error.get
    var errNode = newJObject()
    errNode["code"] = %err.code
    errNode["message"] = %err.message
    if err.data.isSome:
      errNode["data"] = err.data.get
    result["error"] = errNode

proc serveWithHTTP*(host: string, port: int, config: Config) {.async.} =
  ## Serve using HTTP transport with JSON API endpoints
  info "Starting MinerU-PDFHub MCP Server with HTTP transport on " & host & ":" & $port
  let serverInstance = newAsyncHttpServer()
  httpServerInstance = serverInstance
  let mcpServer = server

  proc httpCallback(req: Request) {.async, gcsafe.} =
    try:
      case req.reqMethod
      of HttpGet:
        case req.url.path
        of "/":
          if req.headers.hasKey("Accept") and
             req.headers["Accept"].toLowerAscii().contains("text/event-stream"):
            await respondPlain(req, Http400, "Stream mode not supported on HTTP endpoint")
            return
          let payload = %*{
            "name": mcpServer.serverInfo.name,
            "version": mcpServer.serverInfo.version,
            "protocolVersion": MCP_PROTOCOL_VERSION,
            "transport": "http"
          }
          await respondJson(req, Http200, payload)
        of "/ui", "/ui/login":
          await respondHtml(req, Http200, inspectorLoginHtml)
        of "/ui/register":
          await respondHtml(req, Http200, inspectorRegisterHtml)
        of "/ui/app":
          await respondHtml(req, Http200, inspectorUiHtml)
        of "/ui/info":
          let payload = %*{
            "name": mcpServer.serverInfo.name,
            "version": mcpServer.serverInfo.version,
            "protocolVersion": MCP_PROTOCOL_VERSION,
            "transport": config.server.transport,
            "tools": SupportedTools,
            "authRequired": authRequired(config),
            "multiUserEnabled": config.access.multiUserEnabled or
                                (not g_access_manager.isNil and g_access_manager.users.len > 0),
            "defaultRole": config.access.defaultRole,
            "hasUsers": if g_access_manager.isNil: false else: g_access_manager.users.len > 0
          }
          await respondJson(req, Http200, payload)
        of "/ui/auth/profile":
          if not ensureAccessManager(config):
            await respondBadRequest(req, "Access manager not available")
            return
          let (ok, message, token, userOpt) = checkAuthorization(req.headers, config)
          if not ok:
            await respondUnauthorized(req, message)
            return
          var userNode = newJObject()
          if userOpt.isSome():
            userNode = userInfoToJson(g_access_manager, userOpt.get(), includeToken = false)
          else:
            let tokenUser = g_access_manager.getUserByToken(token)
            if tokenUser.isSome():
              userNode = userInfoToJson(g_access_manager, tokenUser.get(), includeToken = false)
          let profilePayload = %*{
            "user": userNode,
            "authRequired": authRequired(config),
            "multiUserEnabled": config.access.multiUserEnabled or
                                 (not g_access_manager.isNil and g_access_manager.users.len > 0)
          }
          await respondJson(req, Http200, profilePayload)
        else:
          await respondPlain(req, Http404, "Not Found")
      of HttpPost:
        case req.url.path
        of "/ui/auth/login":
          if not ensureAccessManager(config):
            await respondBadRequest(req, "Access manager not available")
            return
          if req.body.len == 0:
            await respondBadRequest(req, "Empty request body")
            return
          var payload: JsonNode
          try:
            payload = parseJson(req.body)
          except JsonParsingError:
            await respondBadRequest(req, "Invalid JSON payload")
            return
          if not payload.hasKey("username") or payload["username"].kind != JString:
            await respondBadRequest(req, "Missing 'username' field")
            return
          if not payload.hasKey("password") or payload["password"].kind != JString:
            await respondBadRequest(req, "Missing 'password' field")
            return
          let usernameValue = payload["username"].getStr().strip()
          let passwordValue = payload["password"].getStr()
          if usernameValue.len == 0 or passwordValue.len == 0:
            await respondBadRequest(req, "Username and password cannot be empty")
            return
          let authResult = g_access_manager.authenticate(usernameValue, passwordValue)
          if authResult.isNone():
            await respondUnauthorized(req, "Invalid username or password")
            return
          let user = authResult.get()
          let responsePayload = %*{
            "ok": true,
            "message": "Login successful",
            "token": user.token,
            "user": userInfoToJson(g_access_manager, user, includeToken = true),
            "authRequired": authRequired(config)
          }
          await respondJson(req, Http200, responsePayload)
        of "/ui/auth/register":
          if not ensureAccessManager(config):
            await respondBadRequest(req, "Access manager not available")
            return
          if req.body.len == 0:
            await respondBadRequest(req, "Empty request body")
            return
          var payload: JsonNode
          try:
            payload = parseJson(req.body)
          except JsonParsingError:
            await respondBadRequest(req, "Invalid JSON payload")
            return
          if not payload.hasKey("username") or payload["username"].kind != JString:
            await respondBadRequest(req, "Missing 'username' field")
            return
          if not payload.hasKey("password") or payload["password"].kind != JString:
            await respondBadRequest(req, "Missing 'password' field")
            return
          let usernameValue = payload["username"].getStr().strip()
          let passwordValue = payload["password"].getStr()
          if usernameValue.len == 0 or passwordValue.len == 0:
            await respondBadRequest(req, "Username and password cannot be empty")
            return
          var libraries: seq[string] = @[]
          if payload.hasKey("libraries"):
            let libsNode = payload["libraries"]
            case libsNode.kind
            of JArray:
              for item in libsNode:
                if item.kind == JString:
                  let value = item.getStr().strip()
                  if value.len > 0:
                    libraries.add(value)
            of JString:
              for part in libsNode.getStr().split(','):
                let value = part.strip()
                if value.len > 0:
                  libraries.add(value)
            else:
              discard
          try:
            var created = g_access_manager.registerUser(usernameValue, passwordValue, "", libraries)
            let isFirst = g_access_manager.users.len == 1
            let responsePayload = %*{
              "ok": true,
              "message": "Registration successful",
              "token": created.token,
              "user": userInfoToJson(g_access_manager, created, includeToken = true),
              "authRequired": authRequired(config),
              "isFirstUser": isFirst
            }
            await respondJson(req, Http200, responsePayload)
          except ValueError as e:
            await respondBadRequest(req, e.msg)
          except CatchableError as e:
            await respondJson(req, Http500, %*{"error": e.msg})
        of "/":
          let (ok, message, token, _) = checkAuthorization(req.headers, config)
          if not ok:
            await respondUnauthorized(req, message)
            return
          if req.body.len == 0:
            await respondBadRequest(req, "Empty request body")
            return

          try:
            let jsonRpcRequest = parseJsonRpcMessage(req.body)
            if jsonRpcRequest.`method` == "tools/call" and jsonRpcRequest.params.isSome:
              let paramsNode = jsonRpcRequest.params.get()
              let violation = checkToolAccess(config, token, paramsNode)
              if violation.isSome():
                let id = if jsonRpcRequest.id.isSome(): jsonRpcRequest.id.get() else: JsonRpcId(kind: jridString, str: "")
                let errorResponse = createJsonRpcError(id, -32000, violation.get())
                await respondJson(req, Http200, jsonRpcResponseToJson(errorResponse))
                return
            if jsonRpcRequest.id.isNone:
              # Notifications are processed without response
              discard mcpServer.handleRequest(McpTransport(kind: tkHttp, capabilities: {tcUnicast}), jsonRpcRequest)
              var headers = newHttpHeaders()
              headers["Access-Control-Allow-Origin"] = "*"
              headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type"
              await respondJson(req, Http200, %*{ "jsonrpc": "2.0", "result": nil })
              return

            var transport = McpTransport(kind: tkHttp, capabilities: {tcUnicast})
            let response = mcpServer.handleRequest(transport, jsonRpcRequest)
            let jsonResponse = jsonRpcResponseToJson(response)
            await respondJson(req, Http200, jsonResponse)
          except ValueError as e:
            await respondBadRequest(req, e.msg)
          except JsonParsingError:
            await respondBadRequest(req, "Invalid JSON-RPC payload")
        of "/ui/actions":
          let (ok, message, token, _) = checkAuthorization(req.headers, config)
          if not ok:
            await respondUnauthorized(req, message)
            return
          if req.body.len == 0:
            await respondBadRequest(req, "Empty request body")
            return
          var actionPayload: JsonNode
          try:
            actionPayload = parseJson(req.body)
          except JsonParsingError:
            await respondBadRequest(req, "Invalid JSON payload")
            return
          if not actionPayload.hasKey("tool") or actionPayload["tool"].kind != JString:
            await respondBadRequest(req, "Missing 'tool' field")
            return
          let toolName = actionPayload["tool"].getStr()
          var args = newJObject()
          if actionPayload.hasKey("arguments"):
            args = actionPayload["arguments"]
            if args.kind != JObject:
              await respondBadRequest(req, "'arguments' must be an object")
              return
          if toolName in SupportedTools:
            var paramsNode = newJObject()
            paramsNode["toolName"] = %toolName
            paramsNode["arguments"] = args
            let violation = checkToolAccess(config, token, paramsNode)
            if violation.isSome():
              await respondUnauthorized(req, violation.get())
              return
            let result = dispatchTool(toolName, args)
            await respondJson(req, Http200, %*{
              "tool": toolName,
              "result": result
            })
          else:
            let result = await handleAdminAction(toolName, args, token, config)
            await respondJson(req, Http200, %*{
              "tool": toolName,
              "result": result
            })
        else:
          await respondPlain(req, Http404, "Not Found")
      of HttpOptions:
        case req.url.path
        of "/":
          await respondCors(req, "OPTIONS, GET, POST")
        of "/ui":
          await respondCors(req, "OPTIONS, GET")
        of "/ui/auth/login", "/ui/auth/register":
          await respondCors(req, "OPTIONS, POST")
        of "/ui/auth/profile":
          await respondCors(req, "OPTIONS, GET")
        of "/ui/actions":
          await respondCors(req, "OPTIONS, POST")
        of "/ui/info":
          await respondCors(req, "OPTIONS, GET")
        else:
          await respondCors(req, "OPTIONS")
      else:
        await respondPlain(req, Http405, "Method Not Allowed")
    except Exception as e:
      await respondJson(req, Http500, %*{
        "error": "Internal server error",
        "details": e.msg
      })

  try:
    await serverInstance.serve(Port(port), httpCallback, address = host)
  except CatchableError as e:
    info "HTTP server stopped: " & e.msg
  finally:
    if not serverInstance.isNil:
      serverInstance.close()
    httpServerInstance = nil

proc serveWithSSE*(host: string, port: int, config: Config) {.async.} =
  ## Serve using SSE transport with dedicated SSE and message endpoints
  info "Starting MinerU-PDFHub MCP Server with SSE transport on " & host & ":" & $port
  let serverInstance = newAsyncHttpServer()
  sseServerInstance = serverInstance
  let state = sseState
  let mcpServer = server

  proc sseCallback(req: Request) {.async.} =
    try:
      case req.reqMethod
      of HttpGet:
        case req.url.path
        of "/health":
          let payload = %*{
            "status": "ok",
            "transport": "sse",
            "version": VERSION
          }
          await respondJson(req, Http200, payload)
        of "/ui", "/ui/login":
          await respondHtml(req, Http200, inspectorLoginHtml)
        of "/ui/register":
          await respondHtml(req, Http200, inspectorRegisterHtml)
        of "/ui/app":
          await respondHtml(req, Http200, inspectorUiHtml)
        of "/ui/info":
          let payload = %*{
            "name": mcpServer.serverInfo.name,
            "version": mcpServer.serverInfo.version,
            "protocolVersion": MCP_PROTOCOL_VERSION,
            "transport": config.server.transport,
            "tools": SupportedTools,
            "authRequired": authRequired(config),
            "multiUserEnabled": config.access.multiUserEnabled or
                                 (not g_access_manager.isNil and g_access_manager.users.len > 0),
            "defaultRole": config.access.defaultRole,
            "hasUsers": if g_access_manager.isNil: false else: g_access_manager.users.len > 0
          }
          await respondJson(req, Http200, payload)
        of "/ui/auth/profile":
          if not ensureAccessManager(config):
            await respondBadRequest(req, "Access manager not available")
            return
          let (ok, message, token, userOpt) = checkAuthorization(req.headers, config)
          if not ok:
            await respondUnauthorized(req, message)
            return
          var userNode = newJObject()
          if userOpt.isSome():
            userNode = userInfoToJson(g_access_manager, userOpt.get(), includeToken = false)
          else:
            let tokenUser = g_access_manager.getUserByToken(token)
            if tokenUser.isSome():
              userNode = userInfoToJson(g_access_manager, tokenUser.get(), includeToken = false)
          let profilePayload = %*{
            "user": userNode,
            "authRequired": authRequired(config),
            "multiUserEnabled": config.access.multiUserEnabled or
                                 (not g_access_manager.isNil and g_access_manager.users.len > 0)
          }
          await respondJson(req, Http200, profilePayload)
        of "/sse":
          let (ok, message, _, _) = checkAuthorization(req.headers, config)
          if not ok:
            await respondUnauthorized(req, message)
            return
          let sessionId = generateSessionId()
          var handshake = "HTTP/1.1 200 OK\r\n"
          handshake.add("Content-Type: text/event-stream\r\n")
          handshake.add("Cache-Control: no-cache\r\n")
          handshake.add("Connection: keep-alive\r\n")
          handshake.add("Access-Control-Allow-Origin: *\r\n")
          handshake.add("Access-Control-Allow-Headers: Authorization, Content-Type\r\n")
          handshake.add("\r\n")
          await req.client.send(handshake)
          let client = SseClient(sessionId: sessionId, socket: req.client, closed: false, state: state)
          state.clients[sessionId] = client
          await sendSseEvent(client, "session", sessionId)
          await sendSseJson(client, "tools", %*{"tools": SupportedTools})
          asyncCheck startSseKeepAlive(client, sessionId)
        else:
          await respondPlain(req, Http404, "Not Found")
      of HttpPost:
        case req.url.path
        of "/ui/auth/login":
          if not ensureAccessManager(config):
            await respondBadRequest(req, "Access manager not available")
            return
          if req.body.len == 0:
            await respondBadRequest(req, "Empty request body")
            return
          var payload: JsonNode
          try:
            payload = parseJson(req.body)
          except JsonParsingError:
            await respondBadRequest(req, "Invalid JSON payload")
            return
          if not payload.hasKey("username") or payload["username"].kind != JString:
            await respondBadRequest(req, "Missing 'username' field")
            return
          if not payload.hasKey("password") or payload["password"].kind != JString:
            await respondBadRequest(req, "Missing 'password' field")
            return
          let usernameValue = payload["username"].getStr().strip()
          let passwordValue = payload["password"].getStr()
          if usernameValue.len == 0 or passwordValue.len == 0:
            await respondBadRequest(req, "Username and password cannot be empty")
            return
          let authResult = g_access_manager.authenticate(usernameValue, passwordValue)
          if authResult.isNone():
            await respondUnauthorized(req, "Invalid username or password")
            return
          let user = authResult.get()
          await respondJson(req, Http200, %*{
            "ok": true,
            "message": "Login successful",
            "token": user.token,
            "user": userInfoToJson(g_access_manager, user, includeToken = true),
            "authRequired": authRequired(config)
          })
        of "/ui/auth/register":
          if not ensureAccessManager(config):
            await respondBadRequest(req, "Access manager not available")
            return
          if req.body.len == 0:
            await respondBadRequest(req, "Empty request body")
            return
          var payload: JsonNode
          try:
            payload = parseJson(req.body)
          except JsonParsingError:
            await respondBadRequest(req, "Invalid JSON payload")
            return
          if not payload.hasKey("username") or payload["username"].kind != JString:
            await respondBadRequest(req, "Missing 'username' field")
            return
          if not payload.hasKey("password") or payload["password"].kind != JString:
            await respondBadRequest(req, "Missing 'password' field")
            return
          let usernameValue = payload["username"].getStr().strip()
          let passwordValue = payload["password"].getStr()
          if usernameValue.len == 0 or passwordValue.len == 0:
            await respondBadRequest(req, "Username and password cannot be empty")
            return
          var libraries: seq[string] = @[]
          if payload.hasKey("libraries"):
            let libsNode = payload["libraries"]
            case libsNode.kind
            of JArray:
              for item in libsNode:
                if item.kind == JString:
                  let value = item.getStr().strip()
                  if value.len > 0:
                    libraries.add(value)
            of JString:
              for part in libsNode.getStr().split(','):
                let value = part.strip()
                if value.len > 0:
                  libraries.add(value)
            else:
              discard
          try:
            var created = g_access_manager.registerUser(usernameValue, passwordValue, "", libraries)
            let isFirst = g_access_manager.users.len == 1
            await respondJson(req, Http200, %*{
              "ok": true,
              "message": "Registration successful",
              "token": created.token,
              "user": userInfoToJson(g_access_manager, created, includeToken = true),
              "authRequired": authRequired(config),
              "isFirstUser": isFirst
            })
          except ValueError as e:
            await respondBadRequest(req, e.msg)
          except CatchableError as e:
            await respondJson(req, Http500, %*{"error": e.msg})
        of "/messages":
          let (ok, message, token, _) = checkAuthorization(req.headers, config)
          if not ok:
            await respondUnauthorized(req, message)
            return
          if req.body.len == 0:
            await respondBadRequest(req, "Empty request body")
            return
          var jsonPayload: JsonNode
          try:
            jsonPayload = parseJson(req.body)
          except JsonParsingError:
            await respondBadRequest(req, "Invalid JSON payload")
            return
          if not jsonPayload.hasKey("sessionId"):
            await respondBadRequest(req, "Missing sessionId")
            return
          let sessionId = jsonPayload["sessionId"].getStr()
          if sessionId.len == 0 or sessionId notin state.clients or state.clients[sessionId].closed:
            await respondJson(req, Http404, %*{"error": "Unknown session"})
            return
          let client = state.clients[sessionId]
          if not jsonPayload.hasKey("tool"):
            await respondBadRequest(req, "Missing 'tool' field")
            return
          let toolName = jsonPayload["tool"].getStr()
          var args = if jsonPayload.hasKey("arguments"): jsonPayload["arguments"] else: newJObject()
          if args.kind != JObject:
            await respondBadRequest(req, "'arguments' must be an object")
            return
          if toolName in SupportedTools:
            var paramsNode = newJObject()
            paramsNode["toolName"] = %toolName
            paramsNode["arguments"] = args
            let violation = checkToolAccess(config, token, paramsNode)
            if violation.isSome():
              await respondUnauthorized(req, violation.get())
              return
            let result = dispatchTool(toolName, args)
            await sendSseJson(client, "message", result)
            await respondJson(req, Http200, %*{"status": "ok"})
          else:
            let result = await handleAdminAction(toolName, args, token, config)
            await sendSseJson(client, "message", result)
            await respondJson(req, Http200, %*{"status": "ok"})
        of "/ui/actions":
          let (ok, message, token, _) = checkAuthorization(req.headers, config)
          if not ok:
            await respondUnauthorized(req, message)
            return
          if req.body.len == 0:
            await respondBadRequest(req, "Empty request body")
            return
          var actionPayload: JsonNode
          try:
            actionPayload = parseJson(req.body)
          except JsonParsingError:
            await respondBadRequest(req, "Invalid JSON payload")
            return
          if not actionPayload.hasKey("tool") or actionPayload["tool"].kind != JString:
            await respondBadRequest(req, "Missing 'tool' field")
            return
          let toolName = actionPayload["tool"].getStr()
          var args = newJObject()
          if actionPayload.hasKey("arguments"):
            args = actionPayload["arguments"]
            if args.kind != JObject:
              await respondBadRequest(req, "'arguments' must be an object")
              return
          if toolName in SupportedTools:
            var paramsNode = newJObject()
            paramsNode["toolName"] = %toolName
            paramsNode["arguments"] = args
            let violation = checkToolAccess(config, token, paramsNode)
            if violation.isSome():
              await respondUnauthorized(req, violation.get())
              return
            let result = dispatchTool(toolName, args)
            await respondJson(req, Http200, %*{
              "tool": toolName,
              "result": result
            })
          else:
            let result = await handleAdminAction(toolName, args, token, config)
            await respondJson(req, Http200, %*{
              "tool": toolName,
              "result": result
            })
        else:
          await respondPlain(req, Http404, "Not Found")
      of HttpOptions:
        case req.url.path
        of "/sse", "/messages":
          await respondCors(req, "OPTIONS, GET, POST")
        of "/ui":
          await respondCors(req, "OPTIONS, GET")
        of "/ui/auth/login", "/ui/auth/register":
          await respondCors(req, "OPTIONS, POST")
        of "/ui/auth/profile":
          await respondCors(req, "OPTIONS, GET")
        of "/ui/actions":
          await respondCors(req, "OPTIONS, POST")
        of "/ui/info", "/health":
          await respondCors(req, "OPTIONS, GET")
        else:
          await respondCors(req, "OPTIONS")
      else:
        await respondPlain(req, Http405, "Method Not Allowed")
    except Exception as e:
      await respondJson(req, Http500, %*{
        "error": "Internal server error",
        "details": e.msg
      })

  try:
    await serverInstance.serve(Port(port), sseCallback, address = host)
  except CatchableError as e:
    info "SSE server stopped: " & e.msg
  finally:
    let clientKeys = state.clients.keys.toSeq()
    for sessionId in clientKeys:
      removeSseClient(state, sessionId)
    if not serverInstance.isNil:
      serverInstance.close()
    sseServerInstance = nil

proc main() {.async.} =
  addHandler(newConsoleLogger(lvlInfo))
  randomize()
  info "Starting MinerU-PDFHub MCP Server v" & VERSION
  
  # Load configuration
  let config = loadConfig()
  
  # Initialize global library manager
  g_library_manager = newLibraryManager(config.storage.dataDir)
  
  # Set the global library manager for MCP tools
  setGlobalLibraryManager(g_library_manager)

  if not ensureGitManager(config):
    warn "Git manager initialisation failed; Git UI features will be limited."

  try:
    g_access_manager = newAccessManager(config.access)
    let userCount = g_access_manager.users.len
    if userCount > 0:
      info "Access control enabled (" & $userCount & " account" &
        (if userCount == 1: "" else: "s") & " present)"
    elif config.access.multiUserEnabled:
      info "Access control enabled (default role: " & config.access.defaultRole & ")"
    else:
      info "Access manager initialised (multi-user disabled in configuration)"
  except CatchableError as e:
    g_access_manager = nil
    warn "Failed to initialize access manager: " & e.msg

  if config.integration.enableAutoSync:
    if g_git_manager.isNil:
      warn "Git auto sync disabled: manager is unavailable"
    else:
      try:
        let initialResults = await g_git_manager.syncAll(g_library_manager, config.storage.dataDir)
        for res in initialResults:
          if res.error:
            warn "Git sync failed for " & res.repoId & ": " & res.message
          elif res.updated:
            info "Git sync updated " & res.libraryName & " (" & res.repoId & ") -> " & res.commit
          else:
            info "Git repo " & res.repoId & " is up to date"
        asyncCheck autoSyncLoop(g_git_manager, g_library_manager, config.storage.dataDir, config.integration.syncIntervalMinutes)
        info "Git auto sync enabled (every " & $config.integration.syncIntervalMinutes & " minutes)"
      except CatchableError as e:
        warn "Git integration disabled: " & e.msg
  else:
    info "Git auto sync disabled"
  
  # Start server based on configured transport mode
  case config.server.transport
  of "stdio":
    info "Using stdio transport mode"
    await serveWithStdio()
  of "http":
    info "Using HTTP transport mode on " & config.server.host & ":" & $config.server.port
    await serveWithHTTP(config.server.host, config.server.port, config)
  of "sse":
    info "Using SSE transport mode on " & config.server.host & ":" & $config.server.port
    await serveWithSSE(config.server.host, config.server.port, config)
  else:
    error "Unknown transport mode: " & config.server.transport
    error "Falling back to stdio transport mode"
    await serveWithStdio()

when isMainModule:
  # Check if running as MCP server or CLI
  let args = commandLineParams()
  if args.len > 0 and args[0] != "server":
    # Run as CLI
    waitFor parseCLI()
  else:
    # Run as MCP server
    waitFor main()
