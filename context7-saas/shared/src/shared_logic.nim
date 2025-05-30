## Shared logic for Context7 - compiled to both native and WASM
## This module contains business logic that can be used on both server and client

import std/[json, strutils, sequtils, tables, times]

type
  Library* = object
    id*: string
    name*: string
    version*: string
    description*: string
    tags*: seq[string]
    trustScore*: int
    snippetCount*: int
    lastUpdated*: string
    organization*: string
    
  SearchResult* = object
    libraries*: seq[Library]
    totalCount*: int
    page*: int
    pageSize*: int

# Search scoring algorithm (shared between frontend and backend)
proc calculateSearchScore*(library: Library, query: string): float =
  let queryLower = query.toLowerAscii()
  var score = 0.0
  
  # Exact name match
  if library.name.toLowerAscii() == queryLower:
    score += 100.0
  # Name contains query
  elif queryLower in library.name.toLowerAscii():
    score += 50.0
  
  # Description match
  if queryLower in library.description.toLowerAscii():
    score += 30.0
  
  # Tag match
  for tag in library.tags:
    if queryLower in tag.toLowerAscii():
      score += 20.0
      break
  
  # Boost by trust score
  score += float(library.trustScore) * 2.0
  
  # Boost by snippet count (documentation coverage)
  if library.snippetCount > 100:
    score += 15.0
  elif library.snippetCount > 50:
    score += 10.0
  elif library.snippetCount > 10:
    score += 5.0
  
  result = score

# Version comparison
proc compareVersions*(v1, v2: string): int =
  ## Returns: -1 if v1 < v2, 0 if v1 == v2, 1 if v1 > v2
  let parts1 = v1.split('.')
  let parts2 = v2.split('.')
  
  for i in 0 ..< max(parts1.len, parts2.len):
    let p1 = if i < parts1.len: parseInt(parts1[i]) else: 0
    let p2 = if i < parts2.len: parseInt(parts2[i]) else: 0
    
    if p1 < p2: return -1
    if p1 > p2: return 1
  
  return 0

# Library ID generation
proc generateLibraryId*(org: string, name: string, version: string): string =
  result = "/" & org & "/" & name & "/" & version

# Validation functions
proc isValidLibraryName*(name: string): bool =
  result = name.len > 0 and name.len <= 100 and
           name.allCharsInSet({'a'..'z', 'A'..'Z', '0'..'9', '-', '_', '.'})

proc isValidVersion*(version: string): bool =
  let parts = version.split('.')
  result = parts.len >= 2 and parts.len <= 4 and
           parts.allIt(it.allCharsInSet({'0'..'9'}) and it.len > 0)

proc isValidOrgName*(org: string): bool =
  result = org.len > 0 and org.len <= 50 and
           org.allCharsInSet({'a'..'z', 'A'..'Z', '0'..'9', '-'})

# Export for WASM
when defined(wasm):
  {.emit: """
  var Module = {};
  """.}
  
  proc wasmCalculateSearchScore(libraryJson: cstring, query: cstring): float {.exportc.} =
    let library = parseJson($libraryJson).to(Library)
    result = calculateSearchScore(library, $query)
  
  proc wasmCompareVersions(v1: cstring, v2: cstring): cint {.exportc.} =
    result = cint(compareVersions($v1, $v2))
  
  proc wasmIsValidLibraryName(name: cstring): bool {.exportc.} =
    result = isValidLibraryName($name)
  
  proc wasmIsValidVersion(version: cstring): bool {.exportc.} =
    result = isValidVersion($version)
  
  proc wasmIsValidOrgName(org: cstring): bool {.exportc.} =
    result = isValidOrgName($org)