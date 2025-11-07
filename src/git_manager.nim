##[
  Git Integration Manager - manages Git tracked documentation sources
  Git 集成管理器：维护仓库清单，驱动文档同步的基础数据
]##

import std/[json, os, strutils, tables, sequtils, times, options]
import config_manager

type
  GitRepoDescriptor* = object
    id*: string
    name*: string
    url*: string
    branch*: string
    docsPath*: string
    libraryName*: string
    version*: string
    autoSync*: bool
    lastSyncedAt*: DateTime
    lastCommit*: string
    lastError*: string

  GitManager* = ref object
    config*: GitIntegrationConfig
    repos*: Table[string, GitRepoDescriptor]

proc ensureDir(path: string) =
  let dir = path.parentDir()
  if dir.len > 0:
    createDir(dir)

proc refresh*(manager: GitManager) {.gcsafe.}

proc descriptorFromJson(node: JsonNode, fallbackBranch: string): GitRepoDescriptor =
  result.id = if node.hasKey("id"): node["id"].getStr() else: ""
  result.name = if node.hasKey("name"): node["name"].getStr() else: result.id
  result.url = if node.hasKey("url"): node["url"].getStr() else: ""
  result.branch = if node.hasKey("branch"): node["branch"].getStr() else: fallbackBranch
  result.docsPath = if node.hasKey("docsPath"): node["docsPath"].getStr() else: ""
  result.libraryName = if node.hasKey("libraryName"): node["libraryName"].getStr() else: ""
  result.version = if node.hasKey("version"): node["version"].getStr() else: "latest"
  result.autoSync = if node.hasKey("autoSync"): node["autoSync"].getBool() else: true
  result.lastCommit = if node.hasKey("lastCommit"): node["lastCommit"].getStr() else: ""
  if node.hasKey("lastSyncedAt"):
    try:
      let ts = node["lastSyncedAt"].getInt()
      result.lastSyncedAt = fromUnix(ts).local()
    except:
      result.lastSyncedAt = default(DateTime)
  else:
    result.lastSyncedAt = default(DateTime)
  result.lastError = if node.hasKey("lastError"): node["lastError"].getStr() else: ""

proc descriptorToJson*(descriptor: GitRepoDescriptor): JsonNode =
  let timestamp =
    if descriptor.lastSyncedAt.year == 0: 0
    else: descriptor.lastSyncedAt.toTime().toUnix()
  %*{
    "id": descriptor.id,
    "name": descriptor.name,
    "url": descriptor.url,
    "branch": descriptor.branch,
    "docsPath": descriptor.docsPath,
    "libraryName": descriptor.libraryName,
    "version": descriptor.version,
    "autoSync": descriptor.autoSync,
    "lastSyncedAt": timestamp,
    "lastCommit": descriptor.lastCommit,
    "lastError": descriptor.lastError
  }

## 基于配置文件创建 Git 管理器并立即加载仓库清单
proc newGitManager*(config: GitIntegrationConfig): GitManager =
  ensureDir(config.reposFile)
  result = GitManager(
    config: config,
    repos: initTable[string, GitRepoDescriptor]()
  )
  result.refresh()

## 重新加载仓库配置文件，构建内存字典
proc refresh*(manager: GitManager) {.gcsafe.} =
  manager.repos = initTable[string, GitRepoDescriptor]()
  if not fileExists(manager.config.reposFile):
    writeFile(manager.config.reposFile, """{"repos": []}
""")
    return
  try:
    let content = readFile(manager.config.reposFile)
    if content.len == 0:
      return
    let node = parseJson(content)
    if node.kind == JObject and node.hasKey("repos"):
      for repoNode in node["repos"]:
        var descriptor = descriptorFromJson(repoNode, manager.config.defaultBranch)
        if descriptor.id.len == 0:
          descriptor.id = descriptor.name
        if descriptor.id.len == 0 and descriptor.url.len > 0:
          descriptor.id = descriptor.url.replace("/", "_")
        if descriptor.id.len == 0:
          continue
        manager.repos[descriptor.id] = descriptor
  except JsonParsingError:
    discard

## 将当前仓库列表写回配置文件
proc save*(manager: GitManager) =
  ensureDir(manager.config.reposFile)
  var array = newJArray()
  for _, descriptor in manager.repos:
    array.add(descriptorToJson(descriptor))
  let root = %*{"repos": array}
  writeFile(manager.config.reposFile, root.pretty())

## 新增或更新单个仓库描述，自动补全缺失字段
proc addOrUpdateRepo*(manager: GitManager, descriptor: GitRepoDescriptor) =
  var item = descriptor
  if item.id.len == 0:
    if item.name.len > 0:
      item.id = item.name
    elif item.url.len > 0:
      item.id = item.url.replace("/", "_")
  if item.branch.len == 0:
    item.branch = manager.config.defaultBranch
  if item.id.len == 0:
    raise newException(ValueError, "Git repo descriptor must include an id, name, or url")
  manager.repos[item.id] = item
  manager.save()

## 删除指定 ID 的仓库，返回删除是否成功
proc removeRepo*(manager: GitManager, id: string): bool =
  if id in manager.repos:
    manager.repos.del(id)
    manager.save()
    return true
  false

## 返回仓库描述列表，供 CLI 等调用
proc listRepos*(manager: GitManager): seq[GitRepoDescriptor] =
  toSeq(manager.repos.values)

## 根据库名查找对应的仓库描述
proc repoForLibrary*(manager: GitManager, libraryName: string): Option[GitRepoDescriptor] =
  for descriptor in manager.repos.values:
    if descriptor.libraryName == libraryName:
      return some(descriptor)
  return none(GitRepoDescriptor)
