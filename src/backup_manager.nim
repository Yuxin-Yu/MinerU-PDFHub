##[
  Backup Manager - tracks snapshot metadata for backups and restores
  备份管理器：负责维护快照元数据并执行备份/恢复
]##

import std/[os, strutils, json, times, algorithm, osproc, streams, options]
import config_manager

type
  BackupSnapshot* = object
    id*: string
    createdAt*: DateTime
    path*: string
    sizeBytes*: int64
    notes*: string

  BackupManager* = ref object
    config*: BackupConfig
    dataDir*: string
    snapshots*: seq[BackupSnapshot]
    lastLoadedTick*: int64

proc refresh*(manager: BackupManager) {.gcsafe.}

proc snapshotsFile(manager: BackupManager): string =
  manager.config.backupDir / "backups.json"

proc ensureDirs(manager: BackupManager) =
  createDir(manager.config.backupDir)

proc snapshotFromJson(node: JsonNode): BackupSnapshot =
  result.id = if node.hasKey("id"): node["id"].getStr() else: ""
  if node.hasKey("createdAt"):
    try:
      result.createdAt = fromUnix(node["createdAt"].getInt()).local()
    except:
      result.createdAt = now()
  else:
    result.createdAt = now()
  result.path = if node.hasKey("path"): node["path"].getStr() else: ""
  result.sizeBytes = if node.hasKey("sizeBytes"): int64(node["sizeBytes"].getInt()) else: 0'i64
  result.notes = if node.hasKey("notes"): node["notes"].getStr() else: ""

proc snapshotToJson*(snapshot: BackupSnapshot): JsonNode =
  %*{
    "id": snapshot.id,
    "createdAt": snapshot.createdAt.toTime().toUnix(),
    "path": snapshot.path,
    "sizeBytes": snapshot.sizeBytes,
    "notes": snapshot.notes
  }

proc newBackupManager*(config: BackupConfig, dataDir: string): BackupManager =
  result = BackupManager(
    config: config,
    dataDir: dataDir,
    snapshots: @[],
    lastLoadedTick: -1
  )
  result.refresh()

## 重新加载 snapshots 文件，刷新内存中的快照列表
proc refresh*(manager: BackupManager) {.gcsafe.} =
  manager.ensureDirs()
  let filePath = manager.snapshotsFile()
  var currentTick = -1'i64

  if fileExists(filePath):
    try:
      currentTick = getFileInfo(filePath).lastWriteTime.toUnix()
    except OSError:
      currentTick = -1
  else:
    var empty = newJObject()
    empty["snapshots"] = newJArray()
    writeFile(filePath, empty.pretty())
    try:
      currentTick = getFileInfo(filePath).lastWriteTime.toUnix()
    except OSError:
      currentTick = -1
    manager.snapshots.setLen(0)
    manager.lastLoadedTick = currentTick
    return

  if manager.lastLoadedTick == currentTick and currentTick != -1:
    return

  manager.snapshots.setLen(0)
  try:
    let content = readFile(filePath)
    if content.len == 0:
      manager.lastLoadedTick = currentTick
      return
    let node = parseJson(content)
    if node.kind == JObject and node.hasKey("snapshots"):
      for entry in node["snapshots"]:
        manager.snapshots.add(snapshotFromJson(entry))
      manager.snapshots.sort(proc(a, b: BackupSnapshot): int = cmp(b.createdAt, a.createdAt))
  except JsonParsingError:
    manager.snapshots.setLen(0)
  manager.lastLoadedTick = currentTick

## 将当前快照信息写回磁盘
proc save*(manager: BackupManager) =
  manager.ensureDirs()
  var arr = newJArray()
  for snapshot in manager.snapshots:
    arr.add(snapshotToJson(snapshot))
  var root = newJObject()
  root["snapshots"] = arr
  let filePath = manager.snapshotsFile()
  writeFile(filePath, root.pretty())
  try:
    manager.lastLoadedTick = getFileInfo(filePath).lastWriteTime.toUnix()
  except OSError:
    manager.lastLoadedTick = int64(now().toTime().toUnix())

## 新增快照记录并执行排序及数量限制
proc registerSnapshot*(manager: BackupManager, snapshot: BackupSnapshot) =
  var entry = snapshot
  if entry.id.len == 0:
    entry.id = "snapshot-" & $entry.createdAt.toTime().toUnix()
  manager.snapshots.add(entry)
  manager.snapshots.sort(proc(a, b: BackupSnapshot): int = cmp(b.createdAt, a.createdAt))
  if manager.config.maxSnapshots > 0 and manager.snapshots.len > manager.config.maxSnapshots:
    manager.snapshots = manager.snapshots[0 ..< manager.config.maxSnapshots]
  manager.save()

## 删除快照元数据及对应文件
proc removeSnapshot*(manager: BackupManager, snapshotId: string): bool =
  for i, snapshot in manager.snapshots:
    if snapshot.id == snapshotId:
      manager.snapshots.delete(i)
      manager.save()
      return true
  false

## 返回快照列表
proc listSnapshots*(manager: BackupManager): seq[BackupSnapshot] =
  manager.snapshots

## 根据保留天数与上限清理过期快照
proc pruneExpiredSnapshots*(manager: BackupManager) =
  if manager.config.retentionDays <= 0:
    return
  let cutoff = now() - initDuration(days = manager.config.retentionDays)
  var filtered: seq[BackupSnapshot] = @[]
  for snapshot in manager.snapshots:
    if snapshot.createdAt >= cutoff:
      filtered.add(snapshot)
    else:
      if snapshot.path.len > 0 and fileExists(snapshot.path):
        try:
          removeFile(snapshot.path)
        except OSError:
          discard
  manager.snapshots = filtered
  manager.save()

proc runCommand(command: string, args: seq[string]): tuple[code: int, output: string] =
  var process = startProcess(command, args = args, options = {poUsePath, poStdErrToStdOut})
  var output = ""
  var exitCode = -1
  try:
    output = readAll(process.outputStream)
    exitCode = process.waitForExit()
  finally:
    close(process)
  (exitCode, output)

## 创建 tar.gz 快照并登记元数据，支持可选备注
proc createSnapshot*(manager: BackupManager, note: string = ""): BackupSnapshot =
  manager.ensureDirs()
  manager.pruneExpiredSnapshots()
  if not dirExists(manager.dataDir):
    raise newException(OSError, "Data directory not found: " & manager.dataDir)
  let timestamp = now()
  let snapshotId = "snapshot-" & timestamp.format("yyyyMMddHHmmss")
  let archivePath = manager.config.backupDir / (snapshotId & ".tar.gz")
  let (code, output) = runCommand("tar", @["-czf", archivePath, "-C", manager.dataDir, "."])
  if code != 0:
    if fileExists(archivePath):
      removeFile(archivePath)
    raise newException(OSError, "Failed to create backup: " & output.strip())
  var snapshot = BackupSnapshot(
    id: snapshotId,
    createdAt: timestamp,
    path: archivePath,
    sizeBytes: int64(getFileSize(archivePath)),
    notes: note
  )
  manager.registerSnapshot(snapshot)
  manager.pruneExpiredSnapshots()
  snapshot

proc findSnapshot(manager: BackupManager, snapshotId: string): Option[BackupSnapshot] =
  for snapshot in manager.snapshots:
    if snapshot.id == snapshotId:
      return some(snapshot)
  none(BackupSnapshot)

## 将指定快照解压到数据目录，覆盖现有文件
proc restoreSnapshot*(manager: BackupManager, snapshotId: string) =
  manager.ensureDirs()
  let snapshotOpt = manager.findSnapshot(snapshotId)
  if snapshotOpt.isNone():
    raise newException(ValueError, "Snapshot not found: " & snapshotId)
  let snapshot = snapshotOpt.get()
  if not fileExists(snapshot.path):
    raise newException(OSError, "Snapshot archive missing: " & snapshot.path)
  let tempDir = manager.config.backupDir / (snapshotId & "_restore")
  if dirExists(tempDir):
    removeDir(tempDir)
  createDir(tempDir)
  let (code, output) = runCommand("tar", @["-xzf", snapshot.path, "-C", tempDir])
  if code != 0:
    removeDir(tempDir)
    raise newException(OSError, "Failed to extract backup: " & output.strip())
  if dirExists(manager.dataDir):
    removeDir(manager.dataDir)
  moveDir(tempDir, manager.dataDir)
  manager.refresh()
