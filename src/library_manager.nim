##[
  Library Manager - Handles library registration, storage, and retrieval
  库管理器：负责库的注册、持久化、索引与检索等核心逻辑
]##

import std/[asyncdispatch, json, tables, strutils, sequtils, times, os, hashes, options, math]
export options, sequtils
import std/algorithm

type
  LibraryCodeSample* = object
    language*: string
    code*: string
  
  LibrarySection* = object
    title*: string
    content*: string
    codeSamples*: seq[LibraryCodeSample]
    parentHeading*: string
  
  Library* = object
    name*: string
    version*: string
    description*: string
    docs*: string
    tags*: seq[string]
    sections*: seq[LibrarySection]
    sectionTaxonomy*: Table[string, seq[string]]
    codeLanguageStats*: Table[string, int]
    codeSampleCount*: int
    registeredAt*: DateTime
    lastUpdated*: DateTime
    
  LibraryIndex* = object
    libraries*: Table[string, seq[Library]]  # name -> versions
    searchIndex*: Table[string, seq[string]]  # keyword -> library names
    
  LibraryManager* = ref object
    dataDir*: string
    index*: LibraryIndex

  LibrarySearchMatch* = object
    library*: Library
    score*: float
    reasons*: seq[string]

const
  SearchTokenDelimiters = {' ', '\t', '\n', '\r', ',', '.', ';', ':', '/', '\\', '-', '_', '(', ')', '[', ']', '{', '}', '"', '\'', '|', '+', '&', '?', '!', '#'}

proc containsAtBoundary(text, substr: string): bool =
  let idx = text.find(substr)
  if idx < 0:
    return false
  let before = if idx == 0: '\0' else: text[idx-1]
  before in {'\0', '-', '_', '.', ' ', '/', '\\', ':'} or idx == 0

proc tokenizeLower(text: string): seq[string] =
  for part in text.toLowerAscii().split(SearchTokenDelimiters):
    let token = part.strip()
    if token.len > 0:
      result.add(token)

proc levenshteinDistance(a, b: string): int =
  let lenA = a.len
  let lenB = b.len
  if lenA == 0:
    return lenB
  if lenB == 0:
    return lenA
  var previous = newSeq[int](lenB + 1)
  for j in 0 .. lenB:
    previous[j] = j
  for i in 0 ..< lenA:
    var current = newSeq[int](lenB + 1)
    current[0] = i + 1
    for j in 0 ..< lenB:
      let cost = if a[i] == b[j]: 0 else: 1
      let deletion = current[j] + 1
      let insertion = previous[j + 1] + 1
      let substitution = previous[j] + cost
      current[j + 1] = min(min(deletion, insertion), substitution)
    previous = current
  previous[lenB]

proc normalizedSimilarity(a, b: string): float =
  if a.len == 0 or b.len == 0:
    return 0.0
  let distance = levenshteinDistance(a, b)
  let maxLen = max(a.len, b.len)
  if maxLen == 0:
    return 1.0
  let score = 1.0 - (float(distance) / float(maxLen))
  if score < 0.0: 0.0 else: score

proc addReason(reasons: var seq[string], reason: string) =
  if reason.len == 0:
    return
  if reason notin reasons and reasons.len < 6:
    reasons.add(reason)

## 计算单个库与查询词的匹配分数，并记录命中原因
proc computeLibraryMatch(library: Library, queryLower: string, queryTokens: seq[string]): tuple[score: float, reasons: seq[string]] =
  var total = 0.0
  var reasons: seq[string] = @[]
  let nameLower = library.name.toLowerAscii()
  let nameTokens = tokenizeLower(library.name)
  let tagsLower = library.tags.mapIt(it.toLowerAscii())
  let descriptionLower = library.description.toLowerAscii()

  if queryLower.len > 0:
    if nameLower == queryLower:
      total += 120.0
      addReason(reasons, "exact name match")
    elif nameLower.startsWith(queryLower):
      total += 80.0
      addReason(reasons, "name starts with query")
    elif nameLower.contains(queryLower) and containsAtBoundary(nameLower, queryLower):
      total += 60.0
      addReason(reasons, "name contains query")
    let nameSim = normalizedSimilarity(queryLower, nameLower)
    if nameSim >= 0.5:
      total += nameSim * 70.0
      addReason(reasons, "name similarity " & formatFloat(nameSim * 100.0, ffDecimal, 1) & "%")
    for tag in tagsLower:
      if tag == queryLower:
        total += 50.0
        addReason(reasons, "tag matches query")
        break

  var distinctTokens: seq[string] = @[]
  for token in queryTokens:
    if token.len == 0 or token in distinctTokens:
      continue
    distinctTokens.add(token)
    var bestScore = 0.0
    var bestLabel = ""
    for nameToken in nameTokens:
      if nameToken == token:
        bestScore = 1.0
        bestLabel = "name token '" & token & "'"
        break
      let sim = normalizedSimilarity(token, nameToken)
      if sim > bestScore:
        bestScore = sim
        bestLabel = "name token '" & nameToken & "'"
    if bestScore < 1.0:
      for tag in tagsLower:
        if tag == token:
          bestScore = 1.0
          bestLabel = "tag '" & token & "'"
          break
        let sim = normalizedSimilarity(token, tag)
        if sim > bestScore:
          bestScore = sim
          bestLabel = "tag '" & tag & "'"
    if bestScore < 0.85 and descriptionLower.len > 0 and containsAtBoundary(descriptionLower, token):
      bestScore = max(bestScore, 0.85)
      bestLabel = "description"
    if bestScore > 0.0:
      total += bestScore * 35.0
      addReason(reasons, "matched " & bestLabel)

  if descriptionLower.len > 0 and queryLower.len > 0 and containsAtBoundary(descriptionLower, queryLower):
    total += 12.0
    addReason(reasons, "description contains query")

  if tagsLower.len > 0 and queryLower.len > 0:
    for tag in tagsLower:
      if tag.len > queryLower.len and containsAtBoundary(tag, queryLower):
        total += 18.0
        addReason(reasons, "tag contains query")
        break

  if library.codeSampleCount > 0:
    total += min(12.0, float(library.codeSampleCount) * 0.3)

  if total < 20.0:
    return (0.0, @[])

  if reasons.len > 5:
    reasons = reasons[0 ..< 5]

  (total, reasons)

## 根据查询词返回带打分的匹配结果，供 CLI 与 MCP 工具复用
proc computeSearchMatches*(manager: LibraryManager, query: string): seq[LibrarySearchMatch] =
  let trimmed = query.strip()
  if trimmed.len == 0:
    return @[]

  let queryLower = trimmed.toLowerAscii()
  var queryTokens = tokenizeLower(trimmed)
  if queryTokens.len == 0:
    queryTokens = @[queryLower]

  for name, versions in manager.index.libraries:
    if versions.len == 0:
      continue
    let library = versions[0]
    let (score, reasons) = computeLibraryMatch(library, queryLower, queryTokens)
    if score > 0.0:
      result.add(LibrarySearchMatch(library: library, score: score, reasons: reasons))

  result.sort(proc(a, b: LibrarySearchMatch): int =
    let scoreCmp = cmp(b.score, a.score)
    if scoreCmp != 0:
      return scoreCmp
    return cmp(a.library.name.toLowerAscii(), b.library.name.toLowerAscii())
  )

proc hash*(lib: Library): Hash =
  result = lib.name.hash !& lib.version.hash
  result = !$result

proc countCodeSamples(sections: seq[LibrarySection]): int =
  for section in sections:
    result += section.codeSamples.len

proc extractCodeSampleCount(jsonData: JsonNode): int =
  if jsonData.hasKey("codeSampleCount"):
    return jsonData["codeSampleCount"].getInt()
  if jsonData.hasKey("sections"):
    for sectionJson in jsonData["sections"]:
      if sectionJson.hasKey("codeSamples") and sectionJson["codeSamples"].kind == JArray:
        result += sectionJson["codeSamples"].len

proc getStringField(node: JsonNode, key: string, defaultValue: string = ""): string =
  if node.hasKey(key) and node[key].kind == JString:
    return node[key].getStr()
  defaultValue

proc getIntField(node: JsonNode, key: string, defaultValue: int64): int64 =
  if node.hasKey(key) and node[key].kind in {JInt, JFloat}:
    try:
      return int64(node[key].getInt())
    except:
      try:
        return int64(node[key].getFloat())
      except:
        return defaultValue
  defaultValue

proc parseSectionsFromJson(node: JsonNode): seq[LibrarySection] =
  if node.hasKey("sections") and node["sections"].kind == JArray:
    for sectionJson in node["sections"]:
      var samples: seq[LibraryCodeSample] = @[]
      if sectionJson.hasKey("codeSamples"):
        let samplesJson = sectionJson["codeSamples"]
        if samplesJson.kind == JArray:
          for item in samplesJson:
            if item.kind == JObject and item.hasKey("code"):
              let language = if item.hasKey("language"): item["language"].getStr() else: ""
              samples.add(LibraryCodeSample(language: language, code: item["code"].getStr()))
            else:
              samples.add(LibraryCodeSample(language: "", code: item.getStr()))
        else:
          for item in samplesJson:
            samples.add(LibraryCodeSample(language: "", code: item.getStr()))
      let content = if sectionJson.hasKey("content"): sectionJson["content"].getStr() else: ""
      let parentHeading = if sectionJson.hasKey("parentHeading"): sectionJson["parentHeading"].getStr() else: ""
      result.add(LibrarySection(
        title: if sectionJson.hasKey("title"): sectionJson["title"].getStr() else: "",
        content: content,
        codeSamples: samples,
        parentHeading: parentHeading
      ))


proc buildSectionTaxonomy(sections: seq[LibrarySection]): Table[string, seq[string]] =
  result = initTable[string, seq[string]]()
  for section in sections:
    let parent = section.parentHeading
    if parent.len == 0:
      continue
    if parent notin result:
      result[parent] = @[]
    result[parent].add(section.title)

proc buildCodeLanguageStats(sections: seq[LibrarySection]): Table[string, int] =
  result = initTable[string, int]()
  for section in sections:
    for sample in section.codeSamples:
      var lang = sample.language.strip().toLowerAscii()
      if lang.len == 0:
        lang = "plain"
      if lang in result:
        inc result[lang]
      else:
        result[lang] = 1

proc ensureSectionMetadata(library: var Library) =
  if library.sectionTaxonomy.len == 0:
    library.sectionTaxonomy = buildSectionTaxonomy(library.sections)
  if library.codeLanguageStats.len == 0:
    library.codeLanguageStats = buildCodeLanguageStats(library.sections)
  if library.codeSampleCount == 0:
    library.codeSampleCount = countCodeSamples(library.sections)

proc libraryFromJson*(manager: LibraryManager, jsonData: JsonNode): Library =
  if not (jsonData.hasKey("name") and jsonData.hasKey("version")):
    raise newException(ValueError, "Invalid library JSON: missing name or version")
  var sections = parseSectionsFromJson(jsonData)
  var library = Library(
    name: jsonData["name"].getStr(),
    version: jsonData["version"].getStr(),
    description: getStringField(jsonData, "description"),
    docs: getStringField(jsonData, "docs"),
    tags: if jsonData.hasKey("tags"): jsonData["tags"].to(seq[string]) else: @[],
    sections: sections,
    registeredAt: now(),
    lastUpdated: now()
  )
  library.sectionTaxonomy = initTable[string, seq[string]]()
  if jsonData.hasKey("sectionTaxonomy") and jsonData["sectionTaxonomy"].kind == JObject:
    for parent, children in jsonData["sectionTaxonomy"]:
      if children.kind == JArray:
        var childSeq: seq[string] = @[]
        for child in children:
          if child.kind == JString:
            childSeq.add(child.getStr())
        library.sectionTaxonomy[parent] = childSeq
  library.codeLanguageStats = initTable[string, int]()
  if jsonData.hasKey("codeLanguageStats") and jsonData["codeLanguageStats"].kind == JObject:
    for lang, countNode in jsonData["codeLanguageStats"]:
      try:
        library.codeLanguageStats[lang] = countNode.getInt()
      except:
        discard
  let registeredAt = getIntField(jsonData, "registeredAt", int64(now().toTime().toUnix()))
  let lastUpdated = getIntField(jsonData, "lastUpdated", registeredAt)
  library.registeredAt = fromUnix(int(registeredAt)).local()
  library.lastUpdated = fromUnix(int(lastUpdated)).local()
  if jsonData.hasKey("codeSampleCount"):
    library.codeSampleCount = jsonData["codeSampleCount"].getInt()
  else:
    library.codeSampleCount = extractCodeSampleCount(jsonData)
  library.ensureSectionMetadata()
  library

# Forward declaration
proc loadIndexSync(manager: LibraryManager) {.gcsafe.}
proc extractLibrarySections*(docs: string): seq[LibrarySection] {.gcsafe.}

## 构建新的库管理器实例并加载现有索引
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

proc computeCodeSampleCountFromFile(manager: LibraryManager, name, version: string): int =
  let filePath = manager.getLibraryFile(name, version)
  if fileExists(filePath):
    try:
      let data = parseJson(readFile(filePath))
      return extractCodeSampleCount(data)
    except:
      discard
  return 0

## 将库对象转换为 JSON 节点，供导出与持久化复用
proc libraryToJson*(library: Library): JsonNode =
  var lib = library
  lib.ensureSectionMetadata()
  var sectionsJson = newJArray()
  for section in lib.sections:
    var samplesJson = newJArray()
    for sample in section.codeSamples:
      samplesJson.add(%*{
        "language": sample.language,
        "code": sample.code
      })
    sectionsJson.add(%*{
      "title": section.title,
      "content": section.content,
      "codeSamples": samplesJson,
      "parentHeading": section.parentHeading
    })
  var taxonomyJson = newJObject()
  for parent, children in lib.sectionTaxonomy.pairs:
    var childArr = newJArray()
    for child in children:
      childArr.add(%child)
    taxonomyJson[parent] = childArr
  var languageJson = newJObject()
  for lang, count in lib.codeLanguageStats.pairs:
    languageJson[lang] = %count
  result = %*{
    "name": lib.name,
    "version": lib.version,
    "description": lib.description,
    "docs": lib.docs,
    "tags": lib.tags,
    "sections": sectionsJson,
    "sectionTaxonomy": taxonomyJson,
    "codeLanguageStats": languageJson,
    "codeSampleCount": lib.codeSampleCount,
    "registeredAt": lib.registeredAt.toTime().toUnix(),
    "lastUpdated": lib.lastUpdated.toTime().toUnix()
  }

proc saveLibraryToDisk*(manager: LibraryManager, library: Library) {.async.} =
  let filePath = manager.getLibraryFile(library.name, library.version)
  let jsonData = libraryToJson(library)
  writeFile(filePath, jsonData.pretty())

proc loadLibraryFromDisk*(manager: LibraryManager, name, version: string): Future[Option[Library]] {.async.} =
  let filePath = manager.getLibraryFile(name, version)
  
  if not fileExists(filePath):
    return none(Library)
  
  try:
    let content = readFile(filePath)
    let jsonData = parseJson(content)
    let library = manager.libraryFromJson(jsonData)
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
        "codeSampleCount": lib.codeSampleCount,
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
        var library = Library(
          name: name,
          version: versionJson["version"].getStr(),
          description: versionJson["description"].getStr(),
          docs: "",  # Will be loaded on demand
          tags: versionJson["tags"].to(seq[string]),
          sections: @[],
          registeredAt: fromUnix(versionJson["registeredAt"].getInt()).local(),
          lastUpdated: fromUnix(versionJson["lastUpdated"].getInt()).local()
        )
        library.sectionTaxonomy = initTable[string, seq[string]]()
        library.codeLanguageStats = initTable[string, int]()
        if versionJson.hasKey("codeSampleCount"):
          library.codeSampleCount = versionJson["codeSampleCount"].getInt()
        else:
          library.codeSampleCount = computeCodeSampleCountFromFile(manager, name, library.version)
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

proc loadIndexSync(manager: LibraryManager) {.gcsafe.} =
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
        var library = Library(
          name: name,
          version: versionJson["version"].getStr(),
          description: versionJson["description"].getStr(),
          docs: "",  # Will be loaded on demand
          tags: versionJson["tags"].to(seq[string]),
          sections: @[],
          registeredAt: fromUnix(versionJson["registeredAt"].getInt()).local(),
          lastUpdated: fromUnix(versionJson["lastUpdated"].getInt()).local()
        )
        library.sectionTaxonomy = initTable[string, seq[string]]()
        library.codeLanguageStats = initTable[string, int]()
        if versionJson.hasKey("codeSampleCount"):
          library.codeSampleCount = versionJson["codeSampleCount"].getInt()
        else:
          library.codeSampleCount = computeCodeSampleCountFromFile(manager, name, library.version)
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
  var sectionWords: seq[string] = @[]
  for section in library.sections:
    for part in section.title.toLowerAscii().split({' ', ',', '.', ';', '-', '_'}):
      if part.len > 0:
        sectionWords.add(part)
    for sample in section.codeSamples:
      if sample.language.len > 0:
        sectionWords.add(sample.language.toLowerAscii())
  let allWords = nameWords & descWords & library.tags.mapIt(it.toLowerAscii()) & sectionWords
  
  for word in allWords:
    if word.len > 2:  # Skip very short words
      if word notin manager.index.searchIndex:
        manager.index.searchIndex[word] = @[]
      if library.name notin manager.index.searchIndex[word]:
        manager.index.searchIndex[word].add(library.name)

proc registerLibrary*(manager: LibraryManager, library: Library) {.async.} =
  var lib = library
  lib.lastUpdated = now()
  if lib.sections.len == 0 and lib.docs.len > 0:
    lib.sections = extractLibrarySections(lib.docs)
  if lib.sections.len > 0:
    lib.codeSampleCount = countCodeSamples(lib.sections)
  else:
    lib.codeSampleCount = 0
  ensureSectionMetadata(lib)
  
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

## 将指定库导出为 JSON 文件，便于迁移或备份
proc exportLibrary*(manager: LibraryManager, name: string, version: string = "latest", targetPath: string): Future[bool] {.async.} =
  let libraryOpt = await manager.getLibrary(name, version)
  if libraryOpt.isNone():
    return false
  let library = libraryOpt.get()
  let sourcePath = manager.getLibraryFile(library.name, library.version)
  if not fileExists(sourcePath):
    await manager.saveLibraryToDisk(library)
  let destDir = targetPath.parentDir()
  if destDir.len > 0:
    createDir(destDir)
  copyFile(sourcePath, targetPath)
  return true

## 从磁盘导入库 JSON，并根据配置决定是否覆盖已有版本
proc importLibrary*(manager: LibraryManager, filePath: string, overrideExisting = true): Future[Option[Library]] {.async.} =
  if not fileExists(filePath):
    return none(Library)
  try:
    let content = readFile(filePath)
    let jsonData = parseJson(content)
    var library = manager.libraryFromJson(jsonData)
    if not overrideExisting:
      let existing = await manager.getLibrary(library.name, library.version)
      if existing.isSome():
        return none(Library)
    await manager.registerLibrary(library)
    return some(library)
  except:
    return none(Library)

proc searchLibraries*(manager: LibraryManager, query: string): Future[seq[Library]] {.async.} =
  let matches = manager.computeSearchMatches(query)
  var libraries: seq[Library] = @[]
  for match in matches:
    libraries.add(match.library)
  return libraries

proc listLibraries*(manager: LibraryManager): seq[Library] =
  var results: seq[Library] = @[]
  for name, versions in manager.index.libraries:
    if versions.len > 0:
      results.add(versions[0])  # Latest version only
  return results

proc extractLibrarySections*(docs: string): seq[LibrarySection] {.gcsafe.} =
  let lines = docs.splitLines()
  var sections: seq[LibrarySection] = @[]
  var currentSection: LibrarySection
  var inSection = false
  var inCodeBlock = false
  var codeBuffer: seq[string] = @[]
  var collectedCodes: seq[LibraryCodeSample] = @[]
  var rstCodeBlock = false
  var rstIndent = -1

  var currentLanguage = ""

  proc finishCodeBlock() {.gcsafe.} =
    if codeBuffer.len > 0:
      let codeText = codeBuffer.join("\n").strip(trailing = true)
      if codeText.len > 0:
        collectedCodes.add(LibraryCodeSample(
          language: currentLanguage,
          code: codeText
        ))
    codeBuffer.setLen(0)
    currentLanguage = ""
    rstCodeBlock = false
    rstIndent = -1

  proc finalizeSection() {.gcsafe.} =
    if inSection:
      if inCodeBlock:
        finishCodeBlock()
        inCodeBlock = false
      currentSection.content = currentSection.content.strip(leading = false, trailing = true)
      while currentSection.content.len > 0 and currentSection.content[0] == '\n':
        currentSection.content = currentSection.content[1 ..< currentSection.content.len]
      currentSection.codeSamples = collectedCodes
      sections.add(currentSection)
      collectedCodes = @[]
      codeBuffer.setLen(0)

  proc leadingWhitespaceLen(line: string): int =
    result = 0
    for ch in line:
      case ch
      of ' ':
        inc result
      of '\t':
        inc result
      else:
        break

  for rawLine in lines:
    let line = rawLine
    let trimmed = rawLine.strip()

    if inCodeBlock and rstCodeBlock:
      let indent = leadingWhitespaceLen(rawLine)
      let isBlank = trimmed.len == 0
      if rstIndent < 0:
        if isBlank:
          codeBuffer.add("")
          continue
        if indent == 0:
          finishCodeBlock()
          inCodeBlock = false
        else:
          rstIndent = indent
      if inCodeBlock and rstCodeBlock:
        if not isBlank and indent < rstIndent:
          finishCodeBlock()
          inCodeBlock = false
        else:
          if isBlank:
            codeBuffer.add("")
          else:
            let startIdx = if rstIndent >= rawLine.len: rawLine.len else: rstIndent
            let segment = if startIdx >= rawLine.len: "" else: rawLine[startIdx .. ^1]
            codeBuffer.add(segment)
          continue

    if trimmed.len > 0 and trimmed[0] == '#':
      var hashes = 0
      for ch in trimmed:
        if ch == '#':
          inc hashes
        else:
          break
      if hashes == 3 and trimmed.len > 3:
        let titleText = trimmed[3..^1].strip()
        finalizeSection()
        currentSection = LibrarySection(
          title: titleText,
          content: "",
          codeSamples: @[]
        )
        inSection = true
        inCodeBlock = false
        collectedCodes = @[]
        codeBuffer.setLen(0)
        continue
      elif hashes in {1, 2}:
        finalizeSection()
        inSection = false
        inCodeBlock = false
        collectedCodes = @[]
        codeBuffer.setLen(0)
        continue

    if trimmed.startsWith(".. code-block::"):
      if not inSection:
        continue
      if inCodeBlock:
        finishCodeBlock()
        inCodeBlock = false
      let parts = trimmed.splitWhitespace()
      var lang = ""
      if parts.len >= 3:
        lang = parts[2].strip().toLowerAscii()
      currentLanguage = lang
      inCodeBlock = true
      rstCodeBlock = true
      rstIndent = -1
      codeBuffer.setLen(0)
      continue

    if not inSection:
      continue
    if trimmed.startsWith("```"):
      if inCodeBlock:
        finishCodeBlock()
        inCodeBlock = false
        rstCodeBlock = false
      else:
        inCodeBlock = true
        let fence = trimmed
        var lang = ""
        if fence.len > 3:
          lang = fence[3..^1].strip().toLowerAscii()
        currentLanguage = lang
        codeBuffer.setLen(0)
      continue

    if inCodeBlock:
      codeBuffer.add(line)
    else:
      if currentSection.content.len > 0:
        currentSection.content.add("\n")
      currentSection.content.add(line)

  finalizeSection()
  return sections

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
