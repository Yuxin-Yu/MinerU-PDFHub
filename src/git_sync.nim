##[
  Git Synchronisation Service - clones/updates repos and refreshes libraries
  Git 同步服务：负责克隆/更新仓库并刷新库文档
]##

import std/[os, strutils, times, asyncdispatch, options, osproc, tables, streams]
import library_manager, git_manager

type
  GitSyncResult* = object
    repoId*: string
    libraryName*: string
    updated*: bool
    commit*: string
    message*: string
    error*: bool

proc gitRoot*(storageDir: string): string =
  storageDir / "git"

proc ensureGitRoot*(storageDir: string): string =
  let root = gitRoot(storageDir)
  createDir(root)
  root

proc sanitizeName(value: string): string =
  result = value
  for ch in {'/', '\\', ':', '@', ' '}:
    result = result.replace(ch, '_')
  if result.len == 0:
    result = "repo"

## 在指定目录执行 Git 命令，并返回退出码与输出
proc runGit(args: seq[string], cwd: string): tuple[code: int, output: string] =
  var process = startProcess("git", args = args, workingDir = cwd, options = {poUsePath, poStdErrToStdOut})
  var output = ""
  var exitCode = -1
  try:
    output = readAll(process.outputStream)
    exitCode = process.waitForExit()
  finally:
    close(process)
  (exitCode, output)

## 对单个仓库执行同步，返回是否更新及诊断信息
proc syncRepository*(gitMgr: GitManager, libMgr: LibraryManager, storageDir: string, repoId: string): Future[GitSyncResult] {.async.} =
  if repoId.len == 0:
    return GitSyncResult(repoId: repoId, message: "Repository id missing", error: true)
  if repoId notin gitMgr.repos:
    return GitSyncResult(repoId: repoId, message: "Repository not configured", error: true)
  var descriptor = gitMgr.repos[repoId]
  let gitBase = ensureGitRoot(storageDir)
  let directoryName = sanitizeName(if descriptor.name.len > 0: descriptor.name else: repoId)
  let repoDir = gitBase / directoryName
  var syncResult = GitSyncResult(repoId: repoId, libraryName: descriptor.libraryName, updated: false, message: "")
  var messageParts: seq[string] = @[]
  if descriptor.libraryName.len == 0:
    descriptor.libraryName = if descriptor.name.len > 0: descriptor.name else: repoId
  if descriptor.version.len == 0 or descriptor.version == "latest":
    descriptor.version = if descriptor.branch.len > 0: descriptor.branch else: "latest"

  # Clone or update
  if not dirExists(repoDir):
    createDir(gitBase)
    let cloneArgs = @["clone", "--branch", descriptor.branch, "--single-branch", descriptor.url, repoDir]
    let (code, output) = runGit(cloneArgs, gitBase)
    if code != 0:
      descriptor.lastError = output
      gitMgr.repos[repoId] = descriptor
      gitMgr.save()
      syncResult.message = "git clone failed: " & output.strip()
      syncResult.error = true
      return syncResult
    messageParts.add("cloned")
  else:
    let (fetchCode, fetchOutput) = runGit(@["fetch", "origin", descriptor.branch], repoDir)
    if fetchCode != 0:
      descriptor.lastError = fetchOutput
      gitMgr.repos[repoId] = descriptor
      gitMgr.save()
      syncResult.message = "git fetch failed: " & fetchOutput.strip()
      syncResult.error = true
      return syncResult
    let (checkoutCode, checkoutOutput) = runGit(@["checkout", descriptor.branch], repoDir)
    if checkoutCode != 0:
      descriptor.lastError = checkoutOutput
      gitMgr.repos[repoId] = descriptor
      gitMgr.save()
      syncResult.message = "git checkout failed: " & checkoutOutput.strip()
      syncResult.error = true
      return syncResult
    let (resetCode, resetOutput) = runGit(@["reset", "--hard", "origin/" & descriptor.branch], repoDir)
    if resetCode != 0:
      descriptor.lastError = resetOutput
      gitMgr.repos[repoId] = descriptor
      gitMgr.save()
      syncResult.message = "git reset failed: " & resetOutput.strip()
      syncResult.error = true
      return syncResult
    messageParts.add("updated")

  let (commitCode, commitOutput) = runGit(@["rev-parse", "HEAD"], repoDir)
  if commitCode != 0:
    descriptor.lastError = commitOutput
    gitMgr.repos[repoId] = descriptor
    gitMgr.save()
    syncResult.message = "git rev-parse failed: " & commitOutput.strip()
    syncResult.error = true
    return syncResult
  let commitHash = commitOutput.strip()
  syncResult.commit = commitHash

  let docsFile = repoDir / descriptor.docsPath
  if not fileExists(docsFile):
    descriptor.lastError = "Documentation file not found: " & docsFile
    gitMgr.repos[repoId] = descriptor
    gitMgr.save()
    syncResult.message = descriptor.lastError
    syncResult.error = true
    return syncResult

  if descriptor.lastCommit.len > 0 and descriptor.lastCommit == commitHash:
    descriptor.lastSyncedAt = now()
    descriptor.lastError = ""
    gitMgr.repos[repoId] = descriptor
    gitMgr.save()
    let shortHash = if commitHash.len >= 8: commitHash[0 ..< 8] else: commitHash
    syncResult.message = "up-to-date (commit " & shortHash & ")"
    return syncResult

  let docs = readFile(docsFile)
  var tags: seq[string] = @["git"]
  if descriptor.branch.len > 0:
    tags.add(descriptor.branch)
  let sections = extractLibrarySections(docs)
  let existing = await libMgr.getLibrary(descriptor.libraryName, descriptor.version)
  let registeredAt = if existing.isSome(): existing.get().registeredAt else: now()

  var library = Library(
    name: descriptor.libraryName,
    version: descriptor.version,
    description: "Synced from " & descriptor.url & " (" & descriptor.branch & ")",
    docs: docs,
    tags: tags,
    sections: sections,
    registeredAt: registeredAt,
    lastUpdated: now()
  )

  await libMgr.registerLibrary(library)
  descriptor.lastSyncedAt = now()
  descriptor.lastCommit = commitHash
  descriptor.lastError = ""
  gitMgr.repos[repoId] = descriptor
  gitMgr.save()

  syncResult.updated = true
  syncResult.message = (if messageParts.len > 0: messageParts.join(", ") & "; " else: "") & "registered library " & descriptor.libraryName
  return syncResult

## 遍历所有仓库执行同步，可选择跳过已禁用项
proc syncAll*(gitMgr: GitManager, libMgr: LibraryManager, storageDir: string, includeDisabled = false): Future[seq[GitSyncResult]] {.async.} =
  var results: seq[GitSyncResult] = @[]
  for repoId, descriptor in gitMgr.repos.pairs:
    if not includeDisabled and not descriptor.autoSync:
      continue
    let res = await gitMgr.syncRepository(libMgr, storageDir, repoId)
    results.add(res)
  return results

## 自动同步循环任务，按配置的分钟数间隔运行
proc autoSyncLoop*(gitMgr: GitManager, libMgr: LibraryManager, storageDir: string, intervalMinutes: int): Future[void] {.async.} =
  let interval = if intervalMinutes <= 0: 5 else: intervalMinutes
  while true:
    discard await gitMgr.syncAll(libMgr, storageDir)
    await sleepAsync(interval * 60 * 1000)
