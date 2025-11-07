##[
  MCP Tools implementation with proper GC-safety
  MCP 工具实现：提供注册、搜索、文档获取的核心逻辑
]##

import std/[asyncdispatch, json, strutils, times, options, sets]
import library_manager, mcp_helpers, topic_matcher

# Global library manager reference - will be set by main module
var g_library_manager {.threadvar.}: LibraryManager

proc setGlobalLibraryManager*(manager: LibraryManager) =
  ## Set the global library manager instance
  g_library_manager = manager

## 处理库注册请求并返回标准化结果
proc handleRegisterLibrary*(name: string, version: string, docs: string, description: string = ""): JsonNode =
  ## Handle library registration in a GC-safe way
  try:
    if g_library_manager.isNil:
      return createToolErrorResult("Library manager not initialized")
    
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
    
    waitFor g_library_manager.registerLibrary(library)
    return createToolSuccessResult("Library registered successfully: " & name & "@" & version)
  except:
    return createToolErrorResult("Error registering library: " & getCurrentExceptionMsg())

## 处理搜索请求，返回带评分的匹配列表
proc handleSearchLibraries*(query: string): JsonNode =
  ## Handle library search in a GC-safe way
  try:
    if g_library_manager.isNil:
      return createToolErrorResult("Library manager not initialized")
    
    let matches = g_library_manager.computeSearchMatches(query)
    
    if matches.len == 0:
      return createToolSuccessResult("No libraries found matching: " & query)
    
    var resultText = "Found " & $matches.len & " libraries matching: " & query & "\n\n"
    let limit = min(matches.len, 15)
    for i in 0 ..< limit:
      let match = matches[i]
      let lib = match.library
      let scoreStr = formatFloat(match.score, ffDecimal, 1)
      resultText.add("- " & lib.name & "@" & lib.version & " (score " & scoreStr & "): " & lib.description & "\n")
      if match.reasons.len > 0:
        resultText.add("  Reasons: " & match.reasons.join(", ") & "\n")
    if matches.len > limit:
      resultText.add("\n" & $(matches.len - limit) & " additional matches omitted.\n")
    
    return createToolSuccessResult(resultText)
  except:
    return createToolErrorResult("Error searching libraries: " & getCurrentExceptionMsg())

proc buildSectionSnippet(section: LibrarySection): string =
  var snippet = "### " & section.title & "\n"
  if section.content.len > 0:
    snippet.add(section.content & "\n")
  for codeSample in section.codeSamples:
    let language = codeSample.language.strip()
    let fenceLang = if language.len > 0: language else: ""
    snippet.add("```" & fenceLang & "\n")
    snippet.add(codeSample.code)
    if not codeSample.code.endsWith("\n"):
      snippet.add("\n")
    snippet.add("```\n\n")
  if not snippet.endsWith("\n"):
    snippet.add("\n")
  return snippet

## 获取指定库文档，可选主题过滤与返回长度限制
proc handleGetLibraryDocs*(name: string, version: string = "latest", maxCharacters: int = 5000, topic: string = "", topicMatch: string = "literal"): JsonNode =
  ## Handle getting library documentation in a GC-safe way
  try:
    if g_library_manager.isNil:
      return createToolErrorResult("Library manager not initialized")
    
    let libraryOpt = waitFor g_library_manager.getLibrary(name, version)
    
    if libraryOpt.isNone:
      return createToolErrorResult("Library not found: " & name & "@" & version)
    
    let library = libraryOpt.get()
    let charLimit = if maxCharacters <= 0: high(int) else: maxCharacters
    let userDefinedLimit = maxCharacters > 0
    var topics: seq[string] = @[]
    if topic.len > 0:
      for rawTerm in topic.split(','):
        let term = rawTerm.strip()
        if term.len > 0:
          topics.add(term)
        if topics.len >= 5:
          break
    
    var header = "Documentation for " & library.name & "@" & library.version
    if topics.len > 0:
      header.add(" filtered by topics: " & topics.join(", "))
    header.add(":\n\n")
    
    var resultText = header
    var truncated = false
    
    let algorithm = parseTopicMatchAlgorithm(topicMatch)
    var matches: seq[MatchedSection] = @[]
    var skipClipForCode = false
    
    if topics.len == 0 or library.sections.len == 0:
      var remaining = charLimit - resultText.len
      if remaining < 0:
        remaining = 0
      var docsContent = library.docs
      if remaining > 0 and docsContent.len > remaining:
        docsContent = docsContent[0 ..< remaining]
        truncated = true
      elif remaining == 0 and charLimit <= resultText.len:
        docsContent = ""
        truncated = library.docs.len > 0
      resultText.add(docsContent)
    else:
      matches = matchSections(library.sections, topics, algorithm)
      if matches.len == 0:
        var remaining = charLimit - resultText.len
        if remaining < 0:
          remaining = 0
        var docsContent = library.docs
        if remaining > 0 and docsContent.len > remaining:
          docsContent = docsContent[0 ..< remaining]
          truncated = true
        elif remaining == 0 and charLimit <= resultText.len:
          docsContent = ""
          truncated = library.docs.len > 0
        resultText.add("No matching sections found for provided topics using " & algorithmToString(algorithm) & " alignment.\n\n")
        resultText.add(docsContent)
      else:
        var orderedSelections: seq[MatchedSection] = @[]
        var usedIndices = initHashSet[int]()
        proc addSelection(match: MatchedSection) =
          if match.idx notin usedIndices:
            orderedSelections.add(match)
            usedIndices.incl(match.idx)

        for topicIdx in 0 ..< topics.len:
          for match in matches:
            if topicIdx in match.matchedTopics:
              addSelection(match)
              break

        for match in matches:
          addSelection(match)

        var coveredTopics = initHashSet[int]()
        for match in orderedSelections:
          let section = library.sections[match.idx]
          let snippet = buildSectionSnippet(section)
          if charLimit != high(int) and resultText.len + snippet.len > charLimit:
            if snippet.contains("```"):
              resultText.add(snippet)
              truncated = true
              skipClipForCode = true
            else:
              let remaining = charLimit - resultText.len
              if remaining > 0:
                resultText.add(snippet[0 ..< remaining])
                truncated = true
            break
          resultText.add(snippet)
          for topicIdx in match.matchedTopics:
            coveredTopics.incl(topicIdx)
          if charLimit != high(int) and resultText.len >= charLimit:
            truncated = true
            break

        if charLimit != high(int) and resultText.len < charLimit:
          for idx, section in library.sections.pairs:
            if idx in usedIndices:
              continue
            let snippet = buildSectionSnippet(section)
            if charLimit != high(int) and resultText.len + snippet.len > charLimit:
              if snippet.contains("```"):
                resultText.add(snippet)
                truncated = true
                skipClipForCode = true
              else:
                let remaining = charLimit - resultText.len
                if remaining > 0:
                  resultText.add(snippet[0 ..< remaining])
                  truncated = true
              break
            resultText.add(snippet)
            usedIndices.incl(idx)
            if charLimit != high(int) and resultText.len >= charLimit:
              truncated = true
              break

        if charLimit != high(int) and resultText.len < charLimit:
          var remainingText = library.docs
          if resultText.len + remainingText.len > charLimit:
            remainingText = remainingText[0 ..< (charLimit - resultText.len)]
            truncated = true
          resultText.add(remainingText)
    
    if truncated and userDefinedLimit:
      let note = "\n[Truncated to " & $maxCharacters & " characters]"
      if charLimit == high(int) or skipClipForCode:
        resultText.add(note)
      elif resultText.len + note.len <= charLimit:
        resultText.add(note)
      elif charLimit > note.len:
        let sliceLen = charLimit - note.len
        if sliceLen > 0 and resultText.len > sliceLen:
          resultText = resultText[0 ..< sliceLen]
        resultText.add(note)
      # If there's no room for the note, we skip it to respect the limit.
    
    if userDefinedLimit and charLimit != high(int) and not skipClipForCode:
      if resultText.len > charLimit:
        truncated = true
        resultText = resultText[0 ..< charLimit]
      elif resultText.len < charLimit and library.docs.len + resultText.len > charLimit:
        let deficit = charLimit - resultText.len
        if deficit > 0:
          let extra = library.docs[0 ..< min(deficit, library.docs.len)]
          resultText.add(extra)
          if resultText.len > charLimit:
            resultText = resultText[0 ..< charLimit]
    
    return createToolSuccessResult(resultText)
  except:
    return createToolErrorResult("Error getting library documentation: " & getCurrentExceptionMsg())
