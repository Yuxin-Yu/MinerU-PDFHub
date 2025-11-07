##[
  Configuration Manager - Handles server configuration
  配置管理器：统一读取/写入 YAML 配置并合并环境变量
]##

import std/[os, strutils]

type
  ServerConfig* = object
    host*: string
    port*: int
    transport*: string  # "stdio", "http", "sse"
    
  StorageConfig* = object
    dataDir*: string
    maxLibraries*: int
    maxDocSize*: int  # in bytes
    
  SecurityConfig* = object
    enableAuth*: bool
    apiKeys*: seq[string]
    allowedIps*: seq[string]
    
  GitIntegrationConfig* = object
    enableAutoSync*: bool
    reposFile*: string
    defaultBranch*: string
    syncIntervalMinutes*: int
    autoBootstrap*: bool

  BackupConfig* = object
    enableBackups*: bool
    backupDir*: string
    retentionDays*: int
    maxSnapshots*: int

  AccessControlConfig* = object
    multiUserEnabled*: bool
    usersFile*: string
    rolesFile*: string
    defaultRole*: string
    enforceLibraryScope*: bool
    
  Config* = object
    server*: ServerConfig
    storage*: StorageConfig
    security*: SecurityConfig
    integration*: GitIntegrationConfig
    backup*: BackupConfig
    access*: AccessControlConfig

proc cleanValue(value: string): string =
  result = value.strip()
  if result.len >= 2 and (
    (result[0] == '"' and result[^1] == '"') or
    (result[0] == '\'' and result[^1] == '\'')
  ):
    result = result[1 ..< result.len - 1]

proc parseBoolStrict(value: string, defaultValue: bool): bool =
  let lowered = value.strip().toLowerAscii()
  case lowered
  of "true":
    true
  of "false":
    false
  else:
    defaultValue

proc parseIntSafe(value: string, defaultValue: int, allowNegative = false): int =
  let trimmed = value.strip()
  if trimmed.len == 0:
    return defaultValue
  try:
    let parsed = parseInt(trimmed)
    if not allowNegative and parsed < 0:
      return defaultValue
    parsed
  except ValueError:
    defaultValue

proc parseStringList(value: string): seq[string] =
  var trimmed = value.strip()
  if trimmed.len == 0:
    return @[]
  let commentIdx = trimmed.find('#')
  if commentIdx >= 0:
    trimmed = trimmed[0 ..< commentIdx].strip()
  if trimmed.len == 0:
    return @[]
  if trimmed[0] == '[' and trimmed[^1] == ']':
    trimmed = trimmed[1 ..< trimmed.len - 1].strip()
    if trimmed.len == 0:
      return @[]
    for part in trimmed.split(','):
      let entry = cleanValue(part)
      if entry.len > 0:
        result.add(entry)
  else:
    let entry = cleanValue(trimmed)
    if entry.len > 0:
      result.add(entry)
  result

proc parseCsvList(value: string): seq[string] =
  if value.len == 0:
    return @[]
  for part in value.split(','):
    let trimmed = part.strip()
    if trimmed.len > 0:
      result.add(trimmed)

## 返回内置默认配置，包含数据目录、传输方式、Git/备份/权限默认值
proc getDefaultConfig*(): Config =
  Config(
    server: ServerConfig(
      host: "localhost",
      port: 8080,
      transport: "stdio"
    ),
    storage: StorageConfig(
      dataDir: getHomeDir() / ".opencontext7" / "data",
      maxLibraries: 1000,
      maxDocSize: 10 * 1024 * 1024  # 10MB
    ),
    security: SecurityConfig(
      enableAuth: false,
      apiKeys: @[],
      allowedIps: @["127.0.0.1"]
    ),
    integration: GitIntegrationConfig(
      enableAutoSync: false,
      reposFile: getHomeDir() / ".opencontext7" / "git_repos.json",
      defaultBranch: "main",
      syncIntervalMinutes: 15,
      autoBootstrap: true
    ),
    backup: BackupConfig(
      enableBackups: false,
      backupDir: getHomeDir() / ".opencontext7" / "backups",
      retentionDays: 7,
      maxSnapshots: 10
    ),
    access: AccessControlConfig(
      multiUserEnabled: false,
      usersFile: getHomeDir() / ".opencontext7" / "users.json",
      rolesFile: getHomeDir() / ".opencontext7" / "roles.json",
      defaultRole: "viewer",
      enforceLibraryScope: false
    )
  )

proc getConfigPath*(): string =
  let envPath = getEnv("OPENCONTEXT7_CONFIG", "")
  if envPath.len > 0:
    let dir = envPath.parentDir()
    if dir.len > 0:
      createDir(dir)
    return envPath
  let envDir = getEnv("OPENCONTEXT7_CONFIG_DIR", "")
  let configDir = if envDir.len > 0: envDir else: getHomeDir() / ".opencontext7"
  createDir(configDir)
  return configDir / "config.yaml"

## 将配置序列化为 YAML 文件，若路径为空则写入默认位置
proc saveConfig*(config: Config, path: string = "") =
  let configPath = if path == "": getConfigPath() else: path
  let dir = configPath.parentDir()
  if dir.len > 0:
    createDir(dir)
  
  # Generate properly formatted YAML content
  var content = "server:\n"
  content.add("  host: " & config.server.host & "\n")
  content.add("  port: " & $config.server.port & "\n")
  content.add("  transport: " & config.server.transport & "\n")
  content.add("\n")
  
  content.add("storage:\n")
  content.add("  dataDir: " & config.storage.dataDir & "\n")
  content.add("  maxLibraries: " & $config.storage.maxLibraries & "\n")
  content.add("  maxDocSize: " & $config.storage.maxDocSize & "\n")
  content.add("\n")
  
  content.add("security:\n")
  content.add("  enableAuth: " & $config.security.enableAuth & "\n")
  
  # Handle apiKeys array
  content.add("  apiKeys: [")
  for i, key in config.security.apiKeys:
    if i > 0:
      content.add(", ")
    content.add("\"" & key & "\"")
  content.add("]\n")
  
  # Handle allowedIps array
  content.add("  allowedIps: [")
  for i, ip in config.security.allowedIps:
    if i > 0:
      content.add(", ")
    content.add("\"" & ip & "\"")
  content.add("]\n")

  content.add("\n")
  content.add("integration:\n")
  content.add("  enableAutoSync: " & $config.integration.enableAutoSync & "\n")
  content.add("  reposFile: " & config.integration.reposFile & "\n")
  content.add("  defaultBranch: " & config.integration.defaultBranch & "\n")
  content.add("  syncIntervalMinutes: " & $config.integration.syncIntervalMinutes & "\n")
  content.add("  autoBootstrap: " & $config.integration.autoBootstrap & "\n")

  content.add("\n")
  content.add("backup:\n")
  content.add("  enableBackups: " & $config.backup.enableBackups & "\n")
  content.add("  backupDir: " & config.backup.backupDir & "\n")
  content.add("  retentionDays: " & $config.backup.retentionDays & "\n")
  content.add("  maxSnapshots: " & $config.backup.maxSnapshots & "\n")

  content.add("\n")
  content.add("access:\n")
  content.add("  multiUserEnabled: " & $config.access.multiUserEnabled & "\n")
  content.add("  usersFile: " & config.access.usersFile & "\n")
  content.add("  rolesFile: " & config.access.rolesFile & "\n")
  content.add("  defaultRole: " & config.access.defaultRole & "\n")
  content.add("  enforceLibraryScope: " & $config.access.enforceLibraryScope & "\n")
  
  writeFile(configPath, content)

## 从磁盘读取配置并合并环境变量覆盖；若不存在则创建默认配置
proc loadConfig*(path: string = ""): Config =
  let configPath = if path == "": getConfigPath() else: path
  
  if not fileExists(configPath):
    let defaultConfig = getDefaultConfig()
    saveConfig(defaultConfig, configPath)
    return defaultConfig
  
  let content =
    try:
      readFile(configPath)
    except OSError, IOError:
      ""
  if content.len == 0:
    return getDefaultConfig()
  
  var config = getDefaultConfig()
  var currentSection = ""
  
  for rawLine in content.splitLines():
    let trimmedLine = rawLine.strip()
    if trimmedLine.len == 0 or trimmedLine.startsWith("#"):
      continue
    
    if trimmedLine.endsWith(":") and trimmedLine.find(' ') == -1:
      currentSection = trimmedLine[0 ..< trimmedLine.len - 1].strip().toLowerAscii()
      continue
    
    let colonIdx = trimmedLine.find(':')
    if colonIdx < 0:
      continue
    
    let key = trimmedLine[0 ..< colonIdx].strip().toLowerAscii()
    var rawValue = if colonIdx + 1 < trimmedLine.len: trimmedLine[colonIdx + 1 .. ^1] else: ""
    let commentIdx = rawValue.find('#')
    if commentIdx >= 0:
      rawValue = rawValue[0 ..< commentIdx]
    rawValue = rawValue.strip()
    if rawValue.len == 0:
      continue
    
    let cleanedValue = cleanValue(rawValue)
    
    case currentSection
    of "server":
      case key
      of "host":
        config.server.host = cleanedValue
      of "port":
        config.server.port = parseIntSafe(cleanedValue, config.server.port)
      of "transport":
        let transport = cleanedValue.toLowerAscii()
        if transport in ["stdio", "http", "sse"]:
          config.server.transport = transport
    of "storage":
      case key
      of "datadir":
        config.storage.dataDir = cleanedValue
      of "maxlibraries":
        config.storage.maxLibraries = parseIntSafe(cleanedValue, config.storage.maxLibraries)
      of "maxdocsize":
        config.storage.maxDocSize = parseIntSafe(cleanedValue, config.storage.maxDocSize)
    of "security":
      case key
      of "enableauth":
        config.security.enableAuth = parseBoolStrict(cleanedValue, config.security.enableAuth)
      of "apikeys":
        config.security.apiKeys = parseStringList(rawValue)
      of "allowedips":
        config.security.allowedIps = parseStringList(rawValue)
      else:
        discard
    of "integration":
      case key
      of "enableautosync":
        config.integration.enableAutoSync = parseBoolStrict(cleanedValue, config.integration.enableAutoSync)
      of "reposfile":
        if cleanedValue.len > 0:
          config.integration.reposFile = cleanedValue
      of "defaultbranch":
        if cleanedValue.len > 0:
          config.integration.defaultBranch = cleanedValue
      of "syncintervalminutes":
        config.integration.syncIntervalMinutes = parseIntSafe(cleanedValue, config.integration.syncIntervalMinutes)
      of "autobootstrap":
        config.integration.autoBootstrap = parseBoolStrict(cleanedValue, config.integration.autoBootstrap)
      else:
        discard
    of "backup":
      case key
      of "enablebackups":
        config.backup.enableBackups = parseBoolStrict(cleanedValue, config.backup.enableBackups)
      of "backupdir":
        if cleanedValue.len > 0:
          config.backup.backupDir = cleanedValue
      of "retentiondays":
        config.backup.retentionDays = parseIntSafe(cleanedValue, config.backup.retentionDays)
      of "maxsnapshots":
        config.backup.maxSnapshots = parseIntSafe(cleanedValue, config.backup.maxSnapshots)
      else:
        discard
    of "access":
      case key
      of "multiuserenabled":
        config.access.multiUserEnabled = parseBoolStrict(cleanedValue, config.access.multiUserEnabled)
      of "usersfile":
        if cleanedValue.len > 0:
          config.access.usersFile = cleanedValue
      of "rolesfile":
        if cleanedValue.len > 0:
          config.access.rolesFile = cleanedValue
      of "defaultrole":
        if cleanedValue.len > 0:
          config.access.defaultRole = cleanedValue
      of "enforcelibraryscope":
        config.access.enforceLibraryScope = parseBoolStrict(cleanedValue, config.access.enforceLibraryScope)
      else:
        discard
    else:
      discard
  
  let envHost = getEnv("OPENCONTEXT7_HOST", "")
  if envHost.len > 0:
    config.server.host = envHost
  let envPort = getEnv("OPENCONTEXT7_PORT", "")
  if envPort.len > 0:
    config.server.port = parseIntSafe(envPort, config.server.port)
  let envTransport = getEnv("OPENCONTEXT7_TRANSPORT", "")
  if envTransport.len > 0:
    let t = envTransport.toLowerAscii()
    if t in ["stdio", "http", "sse"]:
      config.server.transport = t
  let envDataDir = getEnv("OPENCONTEXT7_DATA_DIR", "")
  if envDataDir.len > 0:
    config.storage.dataDir = envDataDir
  let envMaxLibraries = getEnv("OPENCONTEXT7_MAX_LIBRARIES", "")
  if envMaxLibraries.len > 0:
    config.storage.maxLibraries = parseIntSafe(envMaxLibraries, config.storage.maxLibraries)
  let envMaxDocSize = getEnv("OPENCONTEXT7_MAX_DOC_SIZE", "")
  if envMaxDocSize.len > 0:
    config.storage.maxDocSize = parseIntSafe(envMaxDocSize, config.storage.maxDocSize)
  let envEnableAuth = getEnv("OPENCONTEXT7_ENABLE_AUTH", "")
  if envEnableAuth.len > 0:
    config.security.enableAuth = parseBoolStrict(envEnableAuth, config.security.enableAuth)
  let envApiKeys = getEnv("OPENCONTEXT7_API_KEYS", "")
  if envApiKeys.len > 0:
    config.security.apiKeys = parseCsvList(envApiKeys)
  let envAllowedIps = getEnv("OPENCONTEXT7_ALLOWED_IPS", "")
  if envAllowedIps.len > 0:
    let overrideIps = parseCsvList(envAllowedIps)
    if overrideIps.len > 0:
      config.security.allowedIps = overrideIps
  let envGitAutoSync = getEnv("OPENCONTEXT7_GIT_AUTOSYNC", "")
  if envGitAutoSync.len > 0:
    config.integration.enableAutoSync = parseBoolStrict(envGitAutoSync, config.integration.enableAutoSync)
  let envGitReposFile = getEnv("OPENCONTEXT7_GIT_REPOS_FILE", "")
  if envGitReposFile.len > 0:
    config.integration.reposFile = envGitReposFile
  let envGitBranch = getEnv("OPENCONTEXT7_GIT_DEFAULT_BRANCH", "")
  if envGitBranch.len > 0:
    config.integration.defaultBranch = envGitBranch
  let envGitInterval = getEnv("OPENCONTEXT7_GIT_SYNC_MINUTES", "")
  if envGitInterval.len > 0:
    config.integration.syncIntervalMinutes = parseIntSafe(envGitInterval, config.integration.syncIntervalMinutes)
  let envGitBootstrap = getEnv("OPENCONTEXT7_GIT_BOOTSTRAP", "")
  if envGitBootstrap.len > 0:
    config.integration.autoBootstrap = parseBoolStrict(envGitBootstrap, config.integration.autoBootstrap)
  let envBackups = getEnv("OPENCONTEXT7_ENABLE_BACKUPS", "")
  if envBackups.len > 0:
    config.backup.enableBackups = parseBoolStrict(envBackups, config.backup.enableBackups)
  let envBackupDir = getEnv("OPENCONTEXT7_BACKUP_DIR", "")
  if envBackupDir.len > 0:
    config.backup.backupDir = envBackupDir
  let envRetention = getEnv("OPENCONTEXT7_BACKUP_RETENTION_DAYS", "")
  if envRetention.len > 0:
    config.backup.retentionDays = parseIntSafe(envRetention, config.backup.retentionDays)
  let envSnapshots = getEnv("OPENCONTEXT7_BACKUP_MAX_SNAPSHOTS", "")
  if envSnapshots.len > 0:
    config.backup.maxSnapshots = parseIntSafe(envSnapshots, config.backup.maxSnapshots)
  let envMultiUser = getEnv("OPENCONTEXT7_MULTI_USER", "")
  if envMultiUser.len > 0:
    config.access.multiUserEnabled = parseBoolStrict(envMultiUser, config.access.multiUserEnabled)
  let envUsersFile = getEnv("OPENCONTEXT7_USERS_FILE", "")
  if envUsersFile.len > 0:
    config.access.usersFile = envUsersFile
  let envRolesFile = getEnv("OPENCONTEXT7_ROLES_FILE", "")
  if envRolesFile.len > 0:
    config.access.rolesFile = envRolesFile
  let envDefaultRole = getEnv("OPENCONTEXT7_DEFAULT_ROLE", "")
  if envDefaultRole.len > 0:
    config.access.defaultRole = envDefaultRole
  let envEnforceScope = getEnv("OPENCONTEXT7_ENFORCE_LIBRARY_SCOPE", "")
  if envEnforceScope.len > 0:
    config.access.enforceLibraryScope = parseBoolStrict(envEnforceScope, config.access.enforceLibraryScope)
  
  return config
