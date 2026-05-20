##[
  CLI Interface - Command line interface for MinerU-PDFHub
  CLI 接口：为 MinerU-PDFHub 提供完整的管理命令
]##

import std/[os, strutils, asyncdispatch, times, options, tables, json, osproc, streams, httpclient]
import library_manager, config_manager, git_manager, git_sync, backup_manager, access_manager

const 
  VERSION = "1.0.0"
  USAGE = """
MinerU-PDFHub v""" & VERSION & """

Usage:
  mineru-pdfhub server                    Start the MCP server
  mineru-pdfhub register <name> <version> <docs_file>  Register a library
  mineru-pdfhub register-pdf <name> <version> <pdf_file> [options]  Register a PDF library via MinerU + LLM
  mineru-pdfhub search <query>            Search for libraries
  mineru-pdfhub get <name> [version]      Get library documentation
  mineru-pdfhub list                      List all libraries
  mineru-pdfhub delete <name> [version]   Delete a library
  mineru-pdfhub config                    Show configuration
  mineru-pdfhub init                      Initialize configuration
  mineru-pdfhub export <name> [--version=VER] <output_file>  Export library documentation as JSON
  mineru-pdfhub import <file> [--override=true]              Import library documentation from JSON
  mineru-pdfhub backup list|create|restore <id>|prune [options]  Manage backups
  mineru-pdfhub users list|add|remove|deactivate|activate ...    Manage access control users
  mineru-pdfhub roles list|add|remove ...                        Manage access control roles
  mineru-pdfhub git list                  List configured Git repositories
  mineru-pdfhub git add <id> <repo_url> <docs_path> [--branch=main] [--library=name] [--version=ver] [--name=display] [--auto-sync=true]
  mineru-pdfhub git remove <id>           Remove a Git repository configuration
  mineru-pdfhub git sync [id]             Sync documentation from configured Git repository (all if omitted)
  register-pdf options:
    --description=TEXT          Library description to store
    --mineru-cmd=CMD            MinerU command (default: mineru)
    --mineru-backend=BACKEND    MinerU backend (default: pipeline)
    --mineru-method=METHOD      MinerU parse method (default: auto)
    --llm-base-url=URL          OpenAI-compatible base URL (or env MINERU_PDFHUB_LLM_BASE_URL)
    --llm-api-key=KEY           LLM API key (or env MINERU_PDFHUB_LLM_API_KEY)
    --llm-model=MODEL           LLM model (or env MINERU_PDFHUB_LLM_MODEL)
    --llm-timeout-ms=N          LLM timeout in milliseconds (default: 120000)
    --llm-max-input-chars=N     Max chars per LLM chunk before auto-splitting (default: 18000)
    --keep-temp=true|false      Keep intermediate files (default: false)
    --temp-dir=PATH             Custom intermediate working directory

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
  echo "MinerU-PDFHub v" & VERSION

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

## 将 CLI 参数中的整数字符串转换为 int，失败时回退默认值
proc parseIntCli(value: string, defaultValue: int): int =
  let trimmed = value.strip()
  if trimmed.len == 0:
    return defaultValue
  try:
    parseInt(trimmed)
  except ValueError:
    defaultValue

proc runCommand(command: string, args: seq[string], workingDir: string = ""): tuple[code: int, output: string] =
  var process: Process
  if workingDir.len > 0:
    process = startProcess(command, args = args, workingDir = workingDir, options = {poUsePath, poStdErrToStdOut})
  else:
    process = startProcess(command, args = args, options = {poUsePath, poStdErrToStdOut})
  var output = ""
  var exitCode = -1
  try:
    output = readAll(process.outputStream)
    exitCode = process.waitForExit()
  finally:
    close(process)
  (exitCode, output)

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

proc resolvePdfTempDir(requested: string): string =
  if requested.len > 0:
    createDir(requested)
    return absolutePath(requested)
  let baseDir = getTempDir() / "mineru-pdfhub-pdf-register"
  createDir(baseDir)
  let stamp = now().format("yyyyMMddHHmmssfff")
  var candidate = baseDir / ("run-" & stamp)
  var idx = 0
  while dirExists(candidate):
    inc idx
    candidate = baseDir / ("run-" & stamp & "-" & $idx)
  createDir(candidate)
  candidate

proc findMineruMarkdown(outputDir: string, pdfStem: string): Option[string] =
  var fallback = ""
  if not dirExists(outputDir):
    return none(string)
  for path in walkDirRec(outputDir):
    if not path.toLowerAscii().endsWith(".md"):
      continue
    let stem = splitFile(path).name
    if stem == pdfStem:
      return some(path)
    if fallback.len == 0:
      fallback = path
  if fallback.len > 0:
    return some(fallback)
  none(string)

proc trimMarkdownFence(markdown: string): string =
  let trimmed = markdown.strip()
  if not trimmed.startsWith("```"):
    return trimmed
  let lines = trimmed.splitLines()
  if lines.len < 2:
    return trimmed
  let last = lines[^1].strip()
  if last != "```":
    return trimmed
  lines[1 ..< lines.len - 1].join("\n").strip()

proc ensureMcpSectionHeadings(markdown: string, libraryName: string, version: string): string =
  var hasH3 = false
  for line in markdown.splitLines():
    if line.strip().startsWith("### "):
      hasH3 = true
      break
  if hasH3:
    return markdown.strip()

  var resultLines: seq[string] = @[]
  var inCodeBlock = false
  for rawLine in markdown.splitLines():
    let trimmed = rawLine.strip()
    if trimmed.startsWith("```"):
      inCodeBlock = not inCodeBlock
      resultLines.add(rawLine)
      continue
    if not inCodeBlock and trimmed.startsWith("#"):
      var hashCount = 0
      for ch in trimmed:
        if ch == '#':
          inc hashCount
        else:
          break
      if hashCount > 0 and trimmed.len > hashCount:
        resultLines.add("### " & trimmed[hashCount .. ^1].strip())
        continue
    resultLines.add(rawLine)

  let candidate = resultLines.join("\n").strip()
  if candidate.len == 0:
    return "# " & libraryName & " " & version & "\n\n### Overview\nNo content extracted."
  candidate

proc buildChatCompletionsUrl(baseUrl: string): string =
  let trimmed = baseUrl.strip()
  if trimmed.len == 0:
    return ""
  if trimmed.endsWith("/chat/completions"):
    return trimmed
  if trimmed.endsWith("/v1"):
    return trimmed & "/chat/completions"
  if trimmed.endsWith("/v1/"):
    return trimmed & "chat/completions"
  if trimmed.endsWith("/"):
    return trimmed & "v1/chat/completions"
  trimmed & "/v1/chat/completions"

proc extractLlmText(response: JsonNode): string =
  if response.hasKey("choices") and response["choices"].kind == JArray and response["choices"].len > 0:
    let choice = response["choices"][0]
    if choice.kind == JObject and choice.hasKey("message"):
      let msg = choice["message"]
      if msg.kind == JObject and msg.hasKey("content"):
        let content = msg["content"]
        case content.kind
        of JString:
          return content.getStr()
        of JArray:
          var parts: seq[string] = @[]
          for item in content:
            if item.kind == JString:
              parts.add(item.getStr())
            elif item.kind == JObject and item.hasKey("text") and item["text"].kind == JString:
              parts.add(item["text"].getStr())
          if parts.len > 0:
            return parts.join("\n")
        else:
          discard
    if choice.kind == JObject and choice.hasKey("text") and choice["text"].kind == JString:
      return choice["text"].getStr()
  ""

proc forceSplitByChars(content: string, maxChars: int): seq[string] =
  let safeMax = if maxChars < 2000: 2000 else: maxChars
  var start = 0
  while start < content.len:
    let stop = min(content.len, start + safeMax)
    let part = content[start ..< stop].strip()
    if part.len > 0:
      result.add(part)
    start = stop

proc splitMarkdownForLlm(markdown: string, maxChars: int): seq[string] =
  let content = markdown.strip()
  let safeMax = if maxChars < 2000: 2000 else: maxChars
  if content.len <= safeMax:
    return @[content]

  var lines = content.splitLines()
  var buffer: seq[string] = @[]
  var bufferChars = 0
  var inCodeBlock = false

  for line in lines:
    let trimmed = line.strip()
    let lineChars = line.len + 1
    let shouldSplit = (bufferChars > 0 and bufferChars + lineChars > safeMax and not inCodeBlock)
    if shouldSplit:
      let chunk = buffer.join("\n").strip()
      if chunk.len > 0:
        if chunk.len <= safeMax:
          result.add(chunk)
        else:
          for part in forceSplitByChars(chunk, safeMax):
            result.add(part)
      buffer = @[]
      bufferChars = 0
    buffer.add(line)
    bufferChars += lineChars
    if trimmed.startsWith("```"):
      inCodeBlock = not inCodeBlock

  let tailChunk = buffer.join("\n").strip()
  if tailChunk.len > 0:
    if tailChunk.len <= safeMax:
      result.add(tailChunk)
    else:
      for part in forceSplitByChars(tailChunk, safeMax):
        result.add(part)
  if result.len == 0:
    result = forceSplitByChars(content, safeMax)

proc convertMarkdownByLlmSingle(inputMarkdown: string, name: string, version: string,
                                baseUrl: string, apiKey: string, model: string,
                                timeoutMs: int, chunkLabel: string = ""): string =
  let endpoint = buildChatCompletionsUrl(baseUrl)
  if endpoint.len == 0:
    raise newException(ValueError, "LLM base URL is required. Use --llm-base-url or MINERU_PDFHUB_LLM_BASE_URL.")
  if model.strip().len == 0:
    raise newException(ValueError, "LLM model is required. Use --llm-model or MINERU_PDFHUB_LLM_MODEL.")

  let systemPrompt = """
You transform PDF-extracted markdown into MinerU-PDFHub-ready documentation.

Rules:
1. Output only markdown, no code fences, no explanations.
2. Preserve technical meaning and code snippets exactly whenever possible.
3. Keep one H1 title and optional H2 grouping, but every retrievable detail section should use H3 headings.
4. Keep concise content and remove scanning noise or duplicated fragments.
5. Keep original language unless the text is clearly corrupted.
"""
  let chunkTip =
    if chunkLabel.len > 0:
      "Chunk context: " & chunkLabel & ". Keep this chunk self-contained and coherent.\n\n"
    else:
      ""
  let userPrompt =
    "Library name: " & name & "\n" &
    "Library version: " & version & "\n\n" &
    chunkTip &
    "Source markdown:\n\n" & inputMarkdown

  let payload = %*{
    "model": model,
    "temperature": 0.1,
    "messages": [
      {
        "role": "system",
        "content": systemPrompt
      },
      {
        "role": "user",
        "content": userPrompt
      }
    ]
  }

  let timeoutValue = if timeoutMs <= 0: 120000 else: timeoutMs
  var client = newHttpClient(timeout = timeoutValue)
  defer: client.close()

  var headers = newHttpHeaders()
  headers["Content-Type"] = "application/json"
  if apiKey.strip().len > 0:
    headers["Authorization"] = "Bearer " & apiKey.strip()

  let resp = client.request(endpoint, httpMethod = HttpPost, headers = headers, body = $payload)
  let statusCode = int(resp.code)
  let respBody = resp.body
  if statusCode < 200 or statusCode >= 300:
    raise newException(IOError, "LLM request failed (" & $statusCode & "): " & respBody)

  let bodyJson = parseJson(respBody)
  let content = extractLlmText(bodyJson).strip()
  if content.len == 0:
    raise newException(IOError, "LLM response did not contain text content.")
  content

proc convertMarkdownByLlm(inputMarkdown: string, name: string, version: string,
                          baseUrl: string, apiKey: string, model: string,
                          timeoutMs: int, maxInputChars: int): string =
  let chunks = splitMarkdownForLlm(inputMarkdown, maxInputChars)
  if chunks.len == 0:
    raise newException(ValueError, "Source markdown is empty after preprocessing.")
  if chunks.len <= 1:
    return convertMarkdownByLlmSingle(chunks[0], name, version, baseUrl, apiKey, model, timeoutMs)

  echo "LLM chunking enabled: ", chunks.len, " chunk(s), max ", maxInputChars, " chars per chunk."
  var converted: seq[string] = @[]
  for i, chunk in chunks:
    let chunkLabel = "part " & $(i + 1) & "/" & $chunks.len
    echo "  - Converting ", chunkLabel, "..."
    let chunkOutput = convertMarkdownByLlmSingle(
      chunk, name, version, baseUrl, apiKey, model, timeoutMs, chunkLabel
    ).strip()
    if chunkOutput.len > 0:
      converted.add(chunkOutput)
  if converted.len == 0:
    raise newException(IOError, "LLM chunk conversion produced empty output.")
  converted.join("\n\n")

proc runMineruMarkdownExtract(pdfFile: string, outputDir: string,
                              mineruCmd: string, mineruBackend: string,
                              mineruMethod: string): tuple[ok: bool, markdownPath: string, logs: string] =
  let absPdf = absolutePath(pdfFile)
  let absOutput = absolutePath(outputDir)
  let args = @["-p", absPdf, "-o", absOutput, "-b", mineruBackend, "-m", mineruMethod]
  var logs: seq[string] = @[]
  let primaryCommand = if mineruCmd.strip().len == 0: "mineru" else: mineruCmd.strip()

  let (mainCode, mainOutput) = runCommand(primaryCommand, args)
  logs.add("[mineru] " & primaryCommand & " " & args.join(" "))
  logs.add(mainOutput)

  var success = mainCode == 0
  if not success:
    let localMineruDir = getCurrentDir() / "MinerU"
    if dirExists(localMineruDir):
      let pyArgs = @["-m", "mineru.cli.client"] & args
      for py in @["python3", "python"]:
        let (code, output) = runCommand(py, pyArgs, localMineruDir)
        logs.add("[fallback] " & py & " " & pyArgs.join(" "))
        logs.add(output)
        if code == 0:
          success = true
          break

  if not success:
    return (false, "", logs.join("\n"))

  let stem = splitFile(absPdf).name
  let mdPath = findMineruMarkdown(absOutput, stem)
  if mdPath.isNone():
    return (false, "", logs.join("\n"))
  (true, mdPath.get(), logs.join("\n"))

proc registerLibraryFromDocs(name: string, version: string, docs: string,
                             dataDir: string = "", description: string = "Library registered via CLI") {.async.} =
  let manager = newLibraryManager(
    if dataDir == "": loadConfig().storage.dataDir else: dataDir
  )

  let library = Library(
    name: name,
    version: version,
    description: description,
    docs: docs,
    tags: @[],
    sections: extractLibrarySections(docs),
    registeredAt: now(),
    lastUpdated: now()
  )

  await manager.registerLibrary(library)
  echo "Library registered: ", name, "@", version

proc registerPdfLibrary(name: string, version: string, pdfFile: string,
                        dataDir: string = "", description: string = "",
                        mineruCmd: string = "mineru", mineruBackend: string = "pipeline",
                        mineruMethod: string = "auto", llmBaseUrl: string = "",
                        llmApiKey: string = "", llmModel: string = "",
                        llmTimeoutMs: int = 120000, llmMaxInputChars: int = 18000,
                        keepTemp = false,
                        tempDir: string = "") {.async.} =
  if not fileExists(pdfFile):
    echo "Error: PDF file not found: ", pdfFile
    quit(1)

  let workDir = resolvePdfTempDir(tempDir)
  let mineruOutDir = workDir / "mineru-output"
  createDir(mineruOutDir)

  var registered = false
  try:
    echo "Step 1/3: Extracting Markdown via MinerU..."
    let extractRes = runMineruMarkdownExtract(pdfFile, mineruOutDir, mineruCmd, mineruBackend, mineruMethod)
    if not extractRes.ok:
      echo "Error: MinerU extraction failed."
      echo extractRes.logs
      quit(1)
    let extractedMdPath = extractRes.markdownPath
    let mineruMarkdown = readFile(extractedMdPath)
    if mineruMarkdown.strip().len == 0:
      echo "Error: MinerU produced empty markdown: ", extractedMdPath
      quit(1)

    echo "Step 2/3: Converting Markdown via LLM..."
    let convertedRaw = convertMarkdownByLlm(
      mineruMarkdown, name, version, llmBaseUrl, llmApiKey, llmModel,
      llmTimeoutMs, llmMaxInputChars
    )
    let convertedDocs = ensureMcpSectionHeadings(trimMarkdownFence(convertedRaw), name, version)
    if convertedDocs.strip().len == 0:
      echo "Error: LLM conversion produced empty markdown."
      quit(1)

    let transformedPath = workDir / "mineru-pdfhub-ready.md"
    writeFile(transformedPath, convertedDocs)

    echo "Step 3/3: Registering library..."
    let finalDescription =
      if description.strip().len > 0:
        description.strip()
      else:
        "Library registered from PDF via MinerU + LLM"
    await registerLibraryFromDocs(name, version, convertedDocs, dataDir, finalDescription)
    registered = true
    if keepTemp:
      echo "Generated docs: ", transformedPath
    else:
      echo "Converted markdown generated and registered (temporary files cleaned)."
  finally:
    if keepTemp:
      echo "Intermediate files kept at: ", workDir
    elif dirExists(workDir):
      try:
        removeDir(workDir)
      except OSError:
        if registered:
          echo "Warning: failed to clean temporary directory: ", workDir

proc registerLibrary*(name, version, docsFile: string, dataDir: string = "") {.async.} =
  if name.strip().len == 0 or version.strip().len == 0 or docsFile.strip().len == 0:
    raise newException(ValueError, "Library name, version, and documentation file are required.")
  if not fileExists(docsFile):
    raise newException(IOError, "Documentation file not found: " & docsFile)
  let docs = readFile(docsFile)
  await registerLibraryFromDocs(name, version, docs, dataDir, "Library registered via CLI")

proc searchLibraries*(query: string, dataDir: string = "") {.async.} =
  if query.strip().len == 0:
    raise newException(ValueError, "Search query is required.")
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
  if name.strip().len == 0:
    raise newException(ValueError, "Library name is required.")
  let manager = newLibraryManager(
    if dataDir == "": loadConfig().storage.dataDir else: dataDir
  )
  
  let library = await manager.getLibrary(name, version)
  
  if library.isNone():
    raise newException(KeyError, "Library not found: " & name & "@" & version)
  
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
  if name.strip().len == 0:
    raise newException(ValueError, "Library name is required.")
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
  let skipServer = getEnv("MINERU_PDFHUB_SKIP_SERVER", "0").toLowerAscii()
  if skipServer in ["1", "true", "yes"]:
    echo "Server command invoked (skipped because MINERU_PDFHUB_SKIP_SERVER is set)."
    return
  echo "Starting MinerU-PDFHub MCP Server..."
  discard execShellCmd("nim c -r src/mineru_pdfhub.nim")

## CLI 入口，根据命令分派到相应子命令处理逻辑
proc parseCLI*(providedArgs: seq[string] = @[]) {.async.} =
  var
    configPath = ""
    dataDir = ""

  let rawArgs = if providedArgs.len > 0: providedArgs else: commandLineParams()
  var args: seq[string] = @[]
  var i = 0
  while i < rawArgs.len:
    let arg = rawArgs[i]
    if arg.startsWith("--config="):
      configPath = arg["--config=".len .. ^1]
    elif arg == "--config":
      if i + 1 >= rawArgs.len:
        echo "Error: --config requires a value"
        quit(1)
      configPath = rawArgs[i + 1]
      inc i
    elif arg.startsWith("--data-dir="):
      dataDir = arg["--data-dir=".len .. ^1]
    elif arg == "--data-dir":
      if i + 1 >= rawArgs.len:
        echo "Error: --data-dir requires a value"
        quit(1)
      dataDir = rawArgs[i + 1]
      inc i
    else:
      args.add(arg)
    inc i

  if args.len == 0:
    showUsage()
    quit(1)
  if args[0] == "--help" or args[0] == "-h":
    showUsage()
    quit(0)
  if args[0] == "--version" or args[0] == "-v":
    showVersion()
    quit(0)
  if args[0].startsWith("-"):
    echo "Unknown option: ", args[0]
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
  of "register-pdf":
    if args.len < 4:
      echo "Error: register-pdf requires name, version, and pdf_file"
      quit(1)
    var description = ""
    var mineruCmd = getEnv("MINERU_PDFHUB_MINERU_CMD", "mineru")
    var mineruBackend = getEnv("MINERU_PDFHUB_MINERU_BACKEND", "pipeline")
    var mineruMethod = getEnv("MINERU_PDFHUB_MINERU_METHOD", "auto")
    var llmBaseUrl = getEnv("MINERU_PDFHUB_LLM_BASE_URL", "")
    var llmApiKey = getEnv("MINERU_PDFHUB_LLM_API_KEY", "")
    var llmModel = getEnv("MINERU_PDFHUB_LLM_MODEL", "")
    var llmTimeoutMs = parseIntCli(getEnv("MINERU_PDFHUB_LLM_TIMEOUT_MS", "120000"), 120000)
    var llmMaxInputChars = parseIntCli(getEnv("MINERU_PDFHUB_LLM_MAX_INPUT_CHARS", "18000"), 18000)
    var keepTemp = parseBoolCli(getEnv("MINERU_PDFHUB_KEEP_TEMP", "false"), false)
    var tempDir = ""

    for i in 4 ..< args.len:
      let param = args[i]
      if param.startsWith("--description="):
        description = param["--description=".len .. ^1]
      elif param.startsWith("--mineru-cmd="):
        mineruCmd = param["--mineru-cmd=".len .. ^1]
      elif param.startsWith("--mineru-backend="):
        mineruBackend = param["--mineru-backend=".len .. ^1]
      elif param.startsWith("--mineru-method="):
        mineruMethod = param["--mineru-method=".len .. ^1]
      elif param.startsWith("--llm-base-url="):
        llmBaseUrl = param["--llm-base-url=".len .. ^1]
      elif param.startsWith("--llm-api-key="):
        llmApiKey = param["--llm-api-key=".len .. ^1]
      elif param.startsWith("--llm-model="):
        llmModel = param["--llm-model=".len .. ^1]
      elif param.startsWith("--llm-timeout-ms="):
        llmTimeoutMs = parseIntCli(param["--llm-timeout-ms=".len .. ^1], llmTimeoutMs)
      elif param.startsWith("--llm-max-input-chars="):
        llmMaxInputChars = parseIntCli(param["--llm-max-input-chars=".len .. ^1], llmMaxInputChars)
      elif param.startsWith("--keep-temp="):
        keepTemp = parseBoolCli(param["--keep-temp=".len .. ^1], keepTemp)
      elif param.startsWith("--temp-dir="):
        tempDir = param["--temp-dir=".len .. ^1]
      elif param.startsWith("--"):
        echo "Unknown option for register-pdf: ", param
        quit(1)
      else:
        echo "Unknown argument for register-pdf: ", param
        quit(1)

    await registerPdfLibrary(
      args[1], args[2], args[3],
      dataDir = dataDir,
      description = description,
      mineruCmd = mineruCmd,
      mineruBackend = mineruBackend,
      mineruMethod = mineruMethod,
      llmBaseUrl = llmBaseUrl,
      llmApiKey = llmApiKey,
      llmModel = llmModel,
      llmTimeoutMs = llmTimeoutMs,
      llmMaxInputChars = llmMaxInputChars,
      keepTemp = keepTemp,
      tempDir = tempDir
    )
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
  try:
    waitFor parseCLI()
  except CatchableError as e:
    echo "Error: ", e.msg
    quit(1)
