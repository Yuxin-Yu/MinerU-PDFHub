##[
  Library Manager - Handles library registration, storage, and retrieval
]##

import std/[asyncdispatch, json, tables, strutils, sequtils, times, os, hashes, options]
import std/algorithm

type
  Library* = object
    name*: string
    version*: string
    description*: string
    docs*: string
    tags*: seq[string]
    registeredAt*: DateTime
    lastUpdated*: DateTime
    
  LibraryIndex* = object
    libraries*: Table[string, seq[Library]]  # name -> versions
    searchIndex*: Table[string, seq[string]]  # keyword -> library names
    
  LibraryManager* = ref object
    dataDir*: string
    index*: LibraryIndex

proc hash*(lib: Library): Hash =
  result = lib.name.hash !& lib.version.hash
  result = !$result

# Forward declaration
proc loadIndexSync(manager: LibraryManager)

proc newLibraryManager*(dataDir: string): LibraryManager =
  createDir(dataDir)
  result = LibraryManager(
    dataDir: dataDir,
    index: LibraryIndex(
      libraries: initTable[string, seq[Library]](),
      searchIndex: initTable[string, seq[string]]()
    )
  )
  
  # Load existing libraries
  result.loadIndexSync()

proc getLibraryFile*(manager: LibraryManager, name, version: string): string =
  let safeName = name.replace("/", "_").replace("\\", "_").replace("@", "_")
  let safeVersion = version.replace("/", "_").replace("\\", "_").replace("@", "_")
  return manager.dataDir / safeName & "_" & safeVersion & ".json"

proc getIndexFile*(manager: LibraryManager): string =
  return manager.dataDir / "index.json"

proc saveLibraryToDisk*(manager: LibraryManager, library: Library) {.async.} =
  let filePath = manager.getLibraryFile(library.name, library.version)
  let jsonData = %*{
    "name": library.name,
    "version": library.version,
    "description": library.description,
    "docs": library.docs,
    "tags": library.tags,
    "registeredAt": library.registeredAt.toTime().toUnix(),
    "lastUpdated": library.lastUpdated.toTime().toUnix()
  }
  
  writeFile(filePath, jsonData.pretty())

proc loadLibraryFromDisk*(manager: LibraryManager, name, version: string): Future[Option[Library]] {.async.} =
  let filePath = manager.getLibraryFile(name, version)
  
  if not fileExists(filePath):
    return none(Library)
  
  try:
    let content = readFile(filePath)
    let jsonData = parseJson(content)
    
    let library = Library(
      name: jsonData["name"].getStr(),
      version: jsonData["version"].getStr(),
      description: jsonData["description"].getStr(),
      docs: jsonData["docs"].getStr(),
      tags: jsonData["tags"].to(seq[string]),
      registeredAt: fromUnix(jsonData["registeredAt"].getInt()).local(),
      lastUpdated: fromUnix(jsonData["lastUpdated"].getInt()).local()
    )
    
    return some(library)
  except:
    return none(Library)

proc saveIndex*(manager: LibraryManager) {.async.} =
  var indexData = newJObject()
  var librariesJson = newJObject()
  
  for name, versions in manager.index.libraries:
    var versionsJson = newJArray()
    for lib in versions:
      versionsJson.add(%*{
        "version": lib.version,
        "description": lib.description,
        "tags": lib.tags,
        "registeredAt": lib.registeredAt.toTime().toUnix(),
        "lastUpdated": lib.lastUpdated.toTime().toUnix()
      })
    librariesJson[name] = versionsJson
  
  indexData["libraries"] = librariesJson
  indexData["searchIndex"] = %manager.index.searchIndex
  
  writeFile(manager.getIndexFile(), indexData.pretty())

proc loadIndex*(manager: LibraryManager) {.async.} =
  let indexFile = manager.getIndexFile()
  
  if not fileExists(indexFile):
    return
  
  try:
    let content = readFile(indexFile)
    let indexData = parseJson(content)
    
    # Load library index
    for name, versionsJson in indexData["libraries"]:
      var versions: seq[Library] = @[]
      for versionJson in versionsJson:
        let library = Library(
          name: name,
          version: versionJson["version"].getStr(),
          description: versionJson["description"].getStr(),
          docs: "",  # Will be loaded on demand
          tags: versionJson["tags"].to(seq[string]),
          registeredAt: fromUnix(versionJson["registeredAt"].getInt()).local(),
          lastUpdated: fromUnix(versionJson["lastUpdated"].getInt()).local()
        )
        versions.add(library)
      # Sort versions by lastUpdated (latest first)
      versions.sort(proc(a, b: Library): int = 
        cmp(b.lastUpdated, a.lastUpdated)
      )
      manager.index.libraries[name] = versions
    
    # Load search index
    if indexData.hasKey("searchIndex"):
      for keyword, namesJson in indexData["searchIndex"]:
        manager.index.searchIndex[keyword] = namesJson.to(seq[string])
  except:
    discard  # Continue with empty index if loading fails

proc loadIndexSync(manager: LibraryManager) =
  let indexFile = manager.getIndexFile()
  
  if not fileExists(indexFile):
    return
  
  try:
    let content = readFile(indexFile)
    let indexData = parseJson(content)
    
    # Load library index
    for name, versionsJson in indexData["libraries"]:
      var versions: seq[Library] = @[]
      for versionJson in versionsJson:
        let library = Library(
          name: name,
          version: versionJson["version"].getStr(),
          description: versionJson["description"].getStr(),
          docs: "",  # Will be loaded on demand
          tags: versionJson["tags"].to(seq[string]),
          registeredAt: fromUnix(versionJson["registeredAt"].getInt()).local(),
          lastUpdated: fromUnix(versionJson["lastUpdated"].getInt()).local()
        )
        versions.add(library)
      # Sort versions by lastUpdated (latest first)
      versions.sort(proc(a, b: Library): int = 
        cmp(b.lastUpdated, a.lastUpdated)
      )
      manager.index.libraries[name] = versions
    
    # Load search index
    if indexData.hasKey("searchIndex"):
      for keyword, namesJson in indexData["searchIndex"]:
        manager.index.searchIndex[keyword] = namesJson.to(seq[string])
  except:
    discard  # Continue with empty index if loading fails

proc updateSearchIndex*(manager: LibraryManager, library: Library) =
  # Add library name to search index
  let nameWords = library.name.toLowerAscii().split({'_', '-', '.', ' '})
  let descWords = library.description.toLowerAscii().split({' ', ',', '.', ';'})
  let allWords = nameWords & descWords & library.tags.mapIt(it.toLowerAscii())
  
  for word in allWords:
    if word.len > 2:  # Skip very short words
      if word notin manager.index.searchIndex:
        manager.index.searchIndex[word] = @[]
      if library.name notin manager.index.searchIndex[word]:
        manager.index.searchIndex[word].add(library.name)

proc registerLibrary*(manager: LibraryManager, library: Library) {.async.} =
  var lib = library
  lib.lastUpdated = now()
  
  # Add to in-memory index
  if lib.name notin manager.index.libraries:
    manager.index.libraries[lib.name] = @[]
  
  # Remove existing version if it exists
  manager.index.libraries[lib.name] = manager.index.libraries[lib.name].filterIt(it.version != lib.version)
  manager.index.libraries[lib.name].add(lib)
  
  # Sort versions (latest first)
  manager.index.libraries[lib.name].sort(proc(a, b: Library): int = 
    cmp(b.lastUpdated, a.lastUpdated)
  )
  
  # Update search index
  manager.updateSearchIndex(lib)
  
  # Save to disk
  await manager.saveLibraryToDisk(lib)
  await manager.saveIndex()

proc getLibrary*(manager: LibraryManager, name: string, version: string = "latest"): Future[Option[Library]] {.async.} =
  if name notin manager.index.libraries:
    return none(Library)
  
  let versions = manager.index.libraries[name]
  if versions.len == 0:
    return none(Library)
  
  let targetVersion = if version == "latest": versions[0].version else: version
  
  for lib in versions:
    if lib.version == targetVersion:
      # Load full library data from disk
      return await manager.loadLibraryFromDisk(lib.name, lib.version)
  
  return none(Library)

proc searchLibraries*(manager: LibraryManager, query: string): Future[seq[Library]] {.async.} =
  var matchingNames: seq[string] = @[]
  let queryWords = query.toLowerAscii().split({' ', ',', '.', ';'})
  
  # Search in index
  for word in queryWords:
    if word in manager.index.searchIndex:
      for name in manager.index.searchIndex[word]:
        if name notin matchingNames:
          matchingNames.add(name)
  
  # Also check for partial matches in library names
  for name in manager.index.libraries.keys():
    if query.toLowerAscii() in name.toLowerAscii() and name notin matchingNames:
      matchingNames.add(name)
  
  # Get latest version of each matching library
  var results: seq[Library] = @[]
  for name in matchingNames:
    if name in manager.index.libraries and manager.index.libraries[name].len > 0:
      let lib = manager.index.libraries[name][0]  # Latest version
      results.add(lib)
  
  return results

proc listLibraries*(manager: LibraryManager): seq[Library] =
  var results: seq[Library] = @[]
  for name, versions in manager.index.libraries:
    if versions.len > 0:
      results.add(versions[0])  # Latest version only
  return results

proc getLibraryCount*(manager: LibraryManager): Future[int] {.async.} =
  return manager.index.libraries.len

proc deleteLibrary*(manager: LibraryManager, name: string, version: string = ""): Future[bool] {.async.} =
  if name notin manager.index.libraries:
    return false
  
  if version == "":
    # Delete all versions
    for lib in manager.index.libraries[name]:
      let filePath = manager.getLibraryFile(lib.name, lib.version)
      if fileExists(filePath):
        removeFile(filePath)
    
    manager.index.libraries.del(name)
    
    # Clean up search index
    for keyword in manager.index.searchIndex.keys():
      manager.index.searchIndex[keyword] = manager.index.searchIndex[keyword].filterIt(it != name)
  else:
    # Delete specific version
    let filePath = manager.getLibraryFile(name, version)
    if fileExists(filePath):
      removeFile(filePath)
    
    manager.index.libraries[name] = manager.index.libraries[name].filterIt(it.version != version)
    
    if manager.index.libraries[name].len == 0:
      manager.index.libraries.del(name)
  
  await manager.saveIndex()
  return true