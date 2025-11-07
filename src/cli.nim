##[
  CLI Interface - Command line interface for OpenContext7
  CLI 接口：为 OpenContext7 提供完整的管理命令
]##

import std/[os, strutils, parseopt, asyncdispatch, times, options, tables]
import library_manager, config_manager, git_manager, git_sync, backup_manager, access_manager

const 
  VERSION = "1.0.0"
  USAGE = """
OpenContext7 v""" & VERSION & """

Usage:
  opencontext7 server                    Start the MCP server
  opencontext7 register <name> <version> <docs_file>  Register a library
  opencontext7 search <query>            Search for libraries
  opencontext7 get <name> [version]      Get library documentation
  opencontext7 list                      List all libraries
  opencontext7 delete <name> [version]   Delete a library
  opencontext7 config                    Show configuration
  opencontext7 init                      Initialize configuration
  opencontext7 export <name> [--version=VER] <output_file>  Export library documentation as JSON
  opencontext7 import <file> [--override=true]              Import library documentation from JSON
  opencontext7 backup list|create|restore <id>|prune [options]  Manage backups
  opencontext7 users list|add|remove|deactivate|activate ...    Manage access control users
  opencontext7 roles list|add|remove ...                        Manage access control roles
  opencontext7 git list                  List configured Git repositories
  opencontext7 git add <id> <repo_url> <docs_path> [--branch=main] [--library=name] [--version=ver] [--name=display] [--auto-sync=true]
  opencontext7 git remove <id>           Remove a Git repository configuration
  opencontext7 git sync [id]             Sync documentation from configured Git repository (all if omitted)

Options:
  -h, --help        Show this help
  -v, --version     Show version
  --config=PATH     Use custom config file
  --data-dir=PATH   Use custom data directory
"""

## 输出 CLI 使用说明，覆盖所有主要命令
proc showUsage*() =
  echo USAGE

## 打印当前 CLI 版本号
proc showVersion*() =
  echo "OpenContext7 v" & VERSION

## 以人类可读格式展示配置文件中的关键信息
proc showConfig(configPath: string = "") =
  let config = loadConfig(configPath)
  echo "Configuration:"
  echo "  Server Host: ", config.server.host
  echo "  Server Port: ", config.server.port
  echo "  Transport: ", config.server.transport
  echo "  Data Directory: ", config.storage.dataDir
  echo "  Max Libraries: ", config.storage.maxLibraries
  echo "  Max Doc Size: ", config.storage.maxDocSize, " bytes"
  echo "  Auth Enabled: ", config.security.enableAuth
  echo "  Git Auto Sync: ", config.integration.enableAutoSync, " (interval: ", config.integration.syncIntervalMinutes, " min)"
  echo "  Git Repos File: ", config.integration.reposFile
  echo "  Backup Enabled: ", config.backup.enableBackups, " -> ", config.backup.backupDir
  echo "  Multi-User Enabled: ", config.access.multiUserEnabled, " (default role: ", config.access.defaultRole, ")"

## 初始化配置文件并立即回显生成的默认配置
proc initConfig(configPath: string = "") =
  let config = getDefaultConfig()
  let path = if configPath == "": getConfigPath() else: configPath
  saveConfig(config, path)
  echo "Configuration initialized at: ", path
  showConfig(path)

## 将 CLI 参数中的布尔值解析为 Nim bool
proc parseBoolCli(value: string, defaultValue: bool): bool =
  let lowered = value.strip().toLowerAscii()
  case lowered
  of "true", "1", "yes", "y":
    true
  of "false", "0", "no", "n":
    false
  else:
    defaultValue

## 将字节数转换为带单位的字符串
proc formatBytes(size: int64): string =
  if size < 1024'i64:
    return $size & " B"
  let units = ["KB", "MB", "GB", "TB"]
  var value = float(size)
  var index = 0
  while value >= 1024 and index < units.len - 1:
    value /= 1024
    inc index
  formatFloat(value, ffDecimal, if index == 0: 1 else: 2) & " " & units[index]

## 将逗号分隔的参数拆分为字符串序列
proc parseCsvCli(value: string): seq[string] =
  if value.len == 0:
    return @[]
  for part in value.split(','):
    let trimmed = part.strip()
    if trimmed.len > 0:
      result.add(trimmed)

## 导出指定库为 JSON 文件，若路径不存在则自动创建
proc exportLibraryCommand(name: string, version: string, outputPath: string, dataDir: string = "") {.async.} =
  let manager = newLibraryManager(
    if dataDir == "": loadConfig().storage.dataDir else: dataDir
  )
  if outputPath.len == 0:
    echo "Error: export requires an output path"
    quit(1)
  let success = await manager.exportLibrary(name, version, outputPath)
  if success:
    echo "Library exported to: ", outputPath
  else:
    echo "Library not found: ", name, if version != "": "@" & version else: ""
    quit(1)

## 从 JSON 文件导入库，可以选择是否覆盖已存在的版本
proc importLibraryCommand(filePath: string, dataDir: string = "", overrideExisting = true) {.async.} =
  let manager = newLibraryManager(
    if dataDir == "": loadConfig().storage.dataDir else: dataDir
  )
  let imported = await manager.importLibrary(filePath, overrideExisting)
  if imported.isNone():
    echo "Failed to import library from: ", filePath
    quit(1)
  let lib = imported.get()
  echo "Imported library: ", lib.name, "@", lib.version

## 根据配置文件和数据目录初始化备份管理器
proc initBackupManager(configPath: string, dataDir: string): tuple[cfg: Config, manager: BackupManager] =
  let cfg = loadConfig(configPath)
  let storageDir = if dataDir == "": cfg.storage.dataDir else: dataDir
  (cfg, newBackupManager(cfg.backup, storageDir))

## 展示现有快照列表和基础信息
proc backupList(configPath: string, dataDir: string) =
  let (_, manager) = initBackupManager(configPath, dataDir)
  let snapshots = manager.listSnapshots()
  if snapshots.len == 0:
    echo "No backups found."
    return
  echo "Available backups (", snapshots.len, ")"
  for snapshot in snapshots:
    let timestamp = snapshot.createdAt.format("yyyy-MM-dd HH:mm:ss")
    echo "  ", snapshot.id, " [", timestamp, "] ", formatBytes(snapshot.sizeBytes), if snapshot.notes.len > 0: " - " & snapshot.notes else: ""

## 创建新的备份快照，可附带说明备注
proc backupCreate(configPath: string, dataDir: string, note: string) =
  let (cfg, manager) = initBackupManager(configPath, dataDir)
  if not cfg.backup.enableBackups:
    echo "Warning: backups are disabled in configuration; proceeding anyway."
  try:
    let snapshot = manager.createSnapshot(note)
    echo "Created backup: ", snapshot.id, " -> ", snapshot.path
  except CatchableError as e:
    echo "Backup failed: ", e.msg
    quit(1)

## 恢复指定 ID 的快照，覆盖当前数据目录
proc backupRestore(configPath: string, dataDir: string, snapshotId: string) =
  let (_, manager) = initBackupManager(configPath, dataDir)
  try:
    manager.restoreSnapshot(snapshotId)
    echo "Restored backup: ", snapshotId
  except CatchableError as e:
    echo "Restore failed: ", e.msg
    quit(1)

## 执行快照保留策略并更新快照列表
proc backupPrune(configPath: string, dataDir: string) =
  let (_, manager) = initBackupManager(configPath, dataDir)
  manager.pruneExpiredSnapshots()
  manager.refresh()
  echo "Pruned expired backups. Remaining: ", manager.snapshots.len

## 读取配置并实例化访问控制管理器
proc loadAccessManager(configPath: string): tuple[cfg: Config, manager: access_manager.AccessManager] =
  let cfg = loadConfig(configPath)
  (cfg, access_manager.newAccessManager(cfg.access))

## 列出所有已注册用户及其角色/可见库
proc usersList(configPath: string) =
  let (_, manager) = loadAccessManager(configPath)
  let userCount = manager.users.len
  if userCount == 0:
    echo "No users defined."
    return
  echo "Configured users (" & $userCount & ")"
  for user in manager.users.values:
    let libs = if user.libraries.len == 0: "*" else: user.libraries.join(", ")
    echo "  ", user.username, " [role: ", user.role, ", active: ", user.active, ", libraries: ", libs, "]"

## 新增或更新用户信息，支持密码、角色与库范围控制
proc usersAdd(configPath: string, username: string, password: Option[string], role: string,
              libraries: Option[seq[string]], active: Option[bool], rotateToken: bool) =
  let (cfg, manager) = loadAccessManager(configPath)
  let trimmedUser = username.strip()
  if trimmedUser.len == 0:
    echo "Username cannot be empty."
    quit(1)

  let existingOpt = manager.getUserByName(trimmedUser)
  if existingOpt.isSome():
    let current = existingOpt.get()
    let desiredRole = if role.len == 0: current.role else: role
    if desiredRole.len > 0 and desiredRole notin manager.roles:
      echo "Unknown role: ", desiredRole
      quit(1)
    let finalRole = if desiredRole.len == 0: cfg.access.defaultRole else: desiredRole
    let finalLibraries = if libraries.isSome(): libraries.get() else: current.libraries
    let finalActive = if active.isSome(): active.get() else: current.active
    let updated = manager.updateUser(
      trimmedUser,
      finalRole,
      finalLibraries,
      finalActive,
      password,
      rotateToken
    )
    echo "User updated: ", updated.username, " (role: ", updated.role, ", active: ", updated.active, ")"
    if rotateToken or password.isSome():
      echo "  New token: ", updated.token
  else:
    if password.isNone() or password.get().len == 0:
      echo "Password is required when creating a new user."
      quit(1)
    let finalRole = if role.len == 0: cfg.access.defaultRole else: role
    if finalRole.len > 0 and finalRole notin manager.roles:
      echo "Unknown role: ", finalRole
      quit(1)
    let libs = if libraries.isSome(): libraries.get() else: @[]
    var created = manager.registerUser(trimmedUser, password.get(), finalRole, libs)
    if active.isSome() and not active.get():
      created = manager.updateUser(trimmedUser, created.role, created.libraries, false)
    echo "User created: ", created.username, " (role: ", created.role, ")"
    echo "  Token: ", created.token

## 删除或停用指定用户
proc usersRemove(configPath: string, username: string, deactivateOnly: bool) =
  let (_, manager) = loadAccessManager(configPath)
  let trimmedUser = username.strip()
  if trimmedUser.len == 0:
    echo "Username cannot be empty."
    quit(1)
  let userOpt = manager.getUserByName(trimmedUser)
  if userOpt.isNone():
    echo "User not found: ", trimmedUser
    quit(1)
  let user = userOpt.get()
  if deactivateOnly:
    discard manager.updateUser(trimmedUser, user.role, user.libraries, false)
    echo "User deactivated: ", trimmedUser
  else:
    if user.token.len == 0:
      echo "User does not have an assigned token and cannot be removed safely."
      quit(1)
    if manager.removeUser(user.token):
      echo "User removed: ", trimmedUser
    else:
      echo "Failed to remove user: ", trimmedUser
      quit(1)

## 重新激活此前被停用的用户
proc usersActivate(configPath: string, username: string) =
  let (_, manager) = loadAccessManager(configPath)
  let trimmedUser = username.strip()
  if trimmedUser.len == 0:
    echo "Username cannot be empty."
    quit(1)
  let userOpt = manager.getUserByName(trimmedUser)
  if userOpt.isNone():
    echo "User not found: ", trimmedUser
    quit(1)
  let user = userOpt.get()
  discard manager.updateUser(trimmedUser, user.role, user.libraries, true)
  echo "User activated: ", trimmedUser

## 列出所有角色及其权限集
proc rolesList(configPath: string) =
  let (_, manager) = loadAccessManager(configPath)
  let roleCount = manager.roles.len
  if roleCount == 0:
    echo "No roles defined."
    return
  echo "Defined roles (" & $roleCount & ")"
  for role in manager.roles.values:
    echo "  ", role.name, " -> ", role.permissions.join(", ")

## 新增或更新角色，并绑定权限列表
proc rolesAdd(configPath: string, name: string, permissions: seq[string]) =
  if permissions.len == 0:
    echo "Error: roles add requires --permissions"
    quit(1)
  let (_, manager) = loadAccessManager(configPath)
  manager.addOrUpdateRole(access_manager.RoleDefinition(name: name, permissions: permissions))
  echo "Role saved: ", name

## 删除指定名称的角色
proc rolesRemove(configPath: string, name: string) =
  let (_, manager) = loadAccessManager(configPath)
  if manager.removeRole(name):
    echo "Role removed: ", name
  else:
    echo "Role not found: ", name
    quit(1)

## 列出当前登记的 Git 仓库状态
proc gitList(configPath: string = "") =
  let cfg = loadConfig(configPath)
  let manager = newGitManager(cfg.integration)
  let repos = manager.listRepos()
  if repos.len == 0:
    echo "No Git repositories configured."
    return
  echo "Configured Git repositories:"
  for repo in repos:
    let status = if repo.lastError.len > 0: "error" else: "ok"
    let lastSync =
      if repo.lastSyncedAt.year == 0: "never"
      else: repo.lastSyncedAt.format("yyyy-MM-dd HH:mm")
    echo "  " & repo.id & " -> " & repo.url &
      " [branch: " & repo.branch & ", docs: " & repo.docsPath &
      ", status: " & status & ", last sync: " & lastSync & "]"

## 删除指定仓库配置
proc gitRemove(configPath: string, repoId: string) =
  if repoId.len == 0:
    echo "Error: git remove requires a repository id"
    quit(1)
  let cfg = loadConfig(configPath)
  let manager = newGitManager(cfg.integration)
  if manager.removeRepo(repoId):
    echo "Removed Git repository: ", repoId
  else:
    echo "Repository not found: ", repoId
    quit(1)

## 新增或更新仓库配置，参数支持分支/库名/自动同步设置
proc gitAdd(configPath: string, args: seq[string]) =
  if args.len < 3:
    echo "Error: git add requires id, repo_url, and docs_path"
    quit(1)
  let repoId = args[0]
  let repoUrl = args[1]
  let docsPath = args[2]
  let cfg = loadConfig(configPath)
  var descriptor = GitRepoDescriptor(
    id: repoId,
    name: repoId,
    url: repoUrl,
    branch: cfg.integration.defaultBranch,
    docsPath: docsPath,
    libraryName: repoId,
    version: cfg.integration.defaultBranch,
    autoSync: true
  )
  for i in 3 ..< args.len:
    let param = args[i]
    if param.startsWith("--branch="):
      let value = param["--branch=".len .. ^1]
      if value.len > 0:
        descriptor.branch = value
    elif param.startsWith("--library="):
      let value = param["--library=".len .. ^1]
      if value.len > 0:
        descriptor.libraryName = value
    elif param.startsWith("--version="):
      let value = param["--version=".len .. ^1]
      if value.len > 0:
        descriptor.version = value
    elif param.startsWith("--name="):
      let value = param["--name=".len .. ^1]
      if value.len > 0:
        descriptor.name = value
    elif param.startsWith("--auto-sync="):
      let value = param["--auto-sync=".len .. ^1]
      descriptor.autoSync = parseBoolCli(value, descriptor.autoSync)
  if descriptor.libraryName.len == 0:
    descriptor.libraryName = descriptor.id
  if descriptor.version.len == 0:
    descriptor.version = descriptor.branch
  let manager = newGitManager(cfg.integration)
  manager.addOrUpdateRepo(descriptor)
  echo "Configured Git repository: ", descriptor.id, " -> ", descriptor.url, " (branch ", descriptor.branch, ")"

## 触发手动同步任务，repoId 为空时同步全部仓库
proc gitSyncCommand(configPath: string, dataDir: string, repoId: string) {.async.} =
  let cfg = loadConfig(configPath)
  let storageDir = if dataDir == "": cfg.storage.dataDir else: dataDir
  let manager = newGitManager(cfg.integration)
  let libManager = newLibraryManager(storageDir)
  if repoId.len == 0:
    let results = await manager.syncAll(libManager, storageDir, true)
    if results.len == 0:
      echo "No Git repositories configured."
      return
    for res in results:
      if res.error:
        echo "[error] ", res.repoId, ": ", res.message
      elif res.updated:
        echo "[updated] ", res.repoId, ": ", res.message
      else:
        echo "[ok] ", res.repoId, ": ", res.message
  else:
    let res = await manager.syncRepository(libManager, storageDir, repoId)
    if res.error:
      echo "[error] ", repoId, ": ", res.message
      quit(1)
    elif res.updated:
      echo "[updated] ", repoId, ": ", res.message
    else:
      echo "[ok] ", repoId, ": ", res.message

proc registerLibrary*(name, version, docsFile: string, dataDir: string = "") {.async.} =
  if not fileExists(docsFile):
    echo "Error: Documentation file not found: ", docsFile
    quit(1)
  
  let docs = readFile(docsFile)
  let manager = newLibraryManager(
    if dataDir == "": loadConfig().storage.dataDir else: dataDir
  )
  
  let library = Library(
    name: name,
    version: version,
    description: "Library registered via CLI",
    docs: docs,
    tags: @[],
    sections: extractLibrarySections(docs),
    registeredAt: now(),
    lastUpdated: now()
  )
  
  await manager.registerLibrary(library)
  echo "Library registered: ", name, "@", version

proc searchLibraries*(query: string, dataDir: string = "") {.async.} =
  let manager = newLibraryManager(
    if dataDir == "": loadConfig().storage.dataDir else: dataDir
  )
  
  let matches = manager.computeSearchMatches(query)
  
  if matches.len == 0:
    echo "No libraries found matching: ", query
  else:
    echo "Found ", matches.len, " libraries:"
    let limit = if matches.len > 10: 10 else: matches.len
    for i in 0 ..< limit:
      let match = matches[i]
      let lib = match.library
      let scoreStr = formatFloat(match.score, ffDecimal, 1)
      echo "  ", lib.name, "@", lib.version, " (score ", scoreStr, ") - ", lib.description
      if match.reasons.len > 0:
        echo "    reasons: ", match.reasons.join(", ")
    if matches.len > limit:
      echo "  ...", matches.len - limit, " more libraries omitted"

proc getLibraryDocs*(name: string, version: string = "latest", dataDir: string = "") {.async.} =
  let manager = newLibraryManager(
    if dataDir == "": loadConfig().storage.dataDir else: dataDir
  )
  
  let library = await manager.getLibrary(name, version)
  
  if library.isNone():
    echo "Library not found: ", name, "@", version
    quit(1)
  
  let lib = library.get()
  echo "Library: ", lib.name, "@", lib.version
  echo "Description: ", lib.description
  echo "Registered: ", lib.registeredAt
  echo "Last Updated: ", lib.lastUpdated
  echo "\nDocumentation:"
  echo "=" .repeat(50)
  echo lib.docs

proc listLibraries*(dataDir: string = "") {.async.} =
  let manager = newLibraryManager(
    if dataDir == "": loadConfig().storage.dataDir else: dataDir
  )
  
  let libraries = manager.listLibraries()
  
  if libraries.len == 0:
    echo "No libraries registered"
  else:
    echo "Registered libraries (", libraries.len, "):"
    for lib in libraries:
      echo "  ", lib.name, "@", lib.version, " (", lib.registeredAt.format("yyyy-MM-dd"), ") - code samples: ", lib.codeSampleCount

proc deleteLibrary*(name: string, version: string = "", dataDir: string = "") {.async.} =
  let manager = newLibraryManager(
    if dataDir == "": loadConfig().storage.dataDir else: dataDir
  )
  
  let success = await manager.deleteLibrary(name, version)
  
  if success:
    if version == "":
      echo "Deleted all versions of library: ", name
    else:
      echo "Deleted library: ", name, "@", version
  else:
    echo "Library not found: ", name, if version != "": "@" & version else: ""

proc runServer*(configPath: string = "", dataDir: string = "") =
  let skipServer = getEnv("OPENCONTEXT7_SKIP_SERVER", "0").toLowerAscii()
  if skipServer in ["1", "true", "yes"]:
    echo "Server command invoked (skipped because OPENCONTEXT7_SKIP_SERVER is set)."
    return
  echo "Starting OpenContext7 MCP Server..."
  discard execShellCmd("nim c -r src/opencontext7.nim")

## CLI 入口，根据命令分派到相应子命令处理逻辑
proc parseCLI*() {.async.} =
  var
    configPath = ""
    dataDir = ""
  
  # Parse options first
  var p = initOptParser()
  for kind, key, val in p.getopt():
    case kind
    of cmdArgument:
      discard  # Will handle arguments later
    of cmdLongOption, cmdShortOption:
      case key
      of "help", "h":
        showUsage()
        quit(0)
      of "version", "v":
        showVersion()
        quit(0)
      of "config":
        configPath = val
      of "data-dir":
        dataDir = val
      else:
        echo "Unknown option: ", key
        quit(1)
    of cmdEnd:
      break
  
  # Parse command and arguments
  let args = commandLineParams()
  if args.len == 0:
    showUsage()
    quit(1)
  
  let command = args[0]
  
  case command
  of "server":
    runServer(configPath, dataDir)
  of "register":
    if args.len < 4:
      echo "Error: register requires name, version, and docs_file"
      quit(1)
    await registerLibrary(args[1], args[2], args[3], dataDir)
  of "search":
    if args.len < 2:
      echo "Error: search requires a query"
      quit(1)
    await searchLibraries(args[1], dataDir)
  of "git":
    if args.len < 2:
      echo "Error: git requires a subcommand (list, add, remove, sync)"
      quit(1)
    let sub = args[1]
    case sub
    of "list":
      gitList(configPath)
    of "add":
      if args.len < 5:
        echo "Error: git add requires id, repo_url, and docs_path"
        quit(1)
      gitAdd(configPath, args[2 .. ^1])
    of "remove":
      if args.len < 3:
        echo "Error: git remove requires a repository id"
        quit(1)
      gitRemove(configPath, args[2])
    of "sync":
      let target = if args.len > 2: args[2] else: ""
      await gitSyncCommand(configPath, dataDir, target)
    else:
      echo "Unknown git subcommand: ", sub
      quit(1)
  of "export":
    if args.len < 3:
      echo "Error: export requires a library name and output path"
      quit(1)
    let name = args[1]
    var version = "latest"
    var outputPath = ""
    var extras: seq[string] = @[]
    for i in 2 ..< args.len:
      let param = args[i]
      if param.startsWith("--version="):
        version = param["--version=".len .. ^1]
      elif param.startsWith("--output="):
        outputPath = param["--output=".len .. ^1]
      elif param.startsWith("--"):
        echo "Unknown option for export: ", param
        quit(1)
      else:
        extras.add(param)
    if outputPath.len == 0 and extras.len > 0:
      outputPath = extras[0]
    await exportLibraryCommand(name, version, outputPath, dataDir)
  of "import":
    if args.len < 2:
      echo "Error: import requires a file path"
      quit(1)
    var filePath = ""
    var overrideExisting = true
    for i in 1 ..< args.len:
      let param = args[i]
      if param.startsWith("--override="):
        overrideExisting = parseBoolCli(param["--override=".len .. ^1], overrideExisting)
      elif param.startsWith("--"):
        echo "Unknown option for import: ", param
        quit(1)
      else:
        filePath = param
    if filePath.len == 0:
      echo "Error: import requires a file path"
      quit(1)
    await importLibraryCommand(filePath, dataDir, overrideExisting)
  of "backup":
    if args.len < 2:
      echo "Error: backup requires a subcommand (list, create, restore, prune)"
      quit(1)
    let sub = args[1]
    case sub
    of "list":
      backupList(configPath, dataDir)
    of "create":
      var note = ""
      for i in 2 ..< args.len:
        let param = args[i]
        if param.startsWith("--note="):
          note = param["--note=".len .. ^1]
        elif param.startsWith("--"):
          echo "Unknown option for backup create: ", param
          quit(1)
        else:
          note = param
      backupCreate(configPath, dataDir, note)
    of "restore":
      if args.len < 3:
        echo "Error: backup restore requires a snapshot id"
        quit(1)
      backupRestore(configPath, dataDir, args[2])
    of "prune":
      backupPrune(configPath, dataDir)
    else:
      echo "Unknown backup subcommand: ", sub
      quit(1)
  of "users":
    if args.len < 2:
      echo "Error: users requires a subcommand (list, add, remove, deactivate, activate)"
      quit(1)
    let sub = args[1]
    case sub
    of "list":
      usersList(configPath)
    of "add":
      if args.len < 3:
        echo "Error: users add requires <username>"
        quit(1)
      let username = args[2]
      var role = ""
      var librariesOpt: Option[seq[string]] = none(seq[string])
      var passwordOpt = none(string)
      var activeOpt = none(bool)
      var rotateToken = false
      for i in 3 ..< args.len:
        let param = args[i]
        if param.startsWith("--role="):
          role = param["--role=".len .. ^1]
        elif param.startsWith("--libraries="):
          librariesOpt = some(parseCsvCli(param["--libraries=".len .. ^1]))
        elif param.startsWith("--password="):
          passwordOpt = some(param["--password=".len .. ^1])
        elif param.startsWith("--active="):
          activeOpt = some(parseBoolCli(param["--active=".len .. ^1], true))
        elif param.startsWith("--inactive"):
          activeOpt = some(false)
        elif param == "--rotate-token":
          rotateToken = true
        elif param.startsWith("--"):
          echo "Unknown option for users add: ", param
          quit(1)
        else:
          echo "Unknown argument for users add: ", param
          quit(1)
      usersAdd(configPath, username, passwordOpt, role, librariesOpt, activeOpt, rotateToken)
    of "remove":
      if args.len < 3:
        echo "Error: users remove requires a username"
        quit(1)
      usersRemove(configPath, args[2], false)
    of "deactivate":
      if args.len < 3:
        echo "Error: users deactivate requires a username"
        quit(1)
      usersRemove(configPath, args[2], true)
    of "activate":
      if args.len < 3:
        echo "Error: users activate requires a username"
        quit(1)
      usersActivate(configPath, args[2])
    else:
      echo "Unknown users subcommand: ", sub
      quit(1)
  of "roles":
    if args.len < 2:
      echo "Error: roles requires a subcommand (list, add, remove)"
      quit(1)
    let sub = args[1]
    case sub
    of "list":
      rolesList(configPath)
    of "add":
      if args.len < 3:
        echo "Error: roles add requires a role name"
        quit(1)
      let name = args[2]
      var permissions: seq[string] = @[]
      for i in 3 ..< args.len:
        let param = args[i]
        if param.startsWith("--permissions="):
          permissions = parseCsvCli(param["--permissions=".len .. ^1])
        elif param.startsWith("--"):
          echo "Unknown option for roles add: ", param
          quit(1)
      rolesAdd(configPath, name, permissions)
    of "remove":
      if args.len < 3:
        echo "Error: roles remove requires a role name"
        quit(1)
      rolesRemove(configPath, args[2])
    else:
      echo "Unknown roles subcommand: ", sub
      quit(1)
  of "get":
    if args.len < 2:
      echo "Error: get requires a library name"
      quit(1)
    let version = if args.len > 2: args[2] else: "latest"
    await getLibraryDocs(args[1], version, dataDir)
  of "list":
    await listLibraries(dataDir)
  of "delete":
    if args.len < 2:
      echo "Error: delete requires a library name"
      quit(1)
    let version = if args.len > 2: args[2] else: ""
    await deleteLibrary(args[1], version, dataDir)
  of "config":
    showConfig(configPath)
  of "init":
    initConfig(configPath)
  else:
    echo "Unknown command: ", command
    showUsage()
    quit(1)

when isMainModule:
  waitFor parseCLI()
