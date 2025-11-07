import std/[unittest, asyncdispatch, asyncnet, httpclient, os, strutils, json, times, httpcore]
import ../src/[opencontext7, library_manager, mcp_tools, config_manager]

proc makeTempDir(prefix: string): string =
  let base = getTempDir()
  var counter = 0
  while true:
    result = base / (prefix & $epochTime() & "_" & $counter)
    inc counter
    if not dirExists(result):
      createDir(result)
      break

proc cleanupDir(path: string) =
  if dirExists(path):
    removeDir(path)

proc assertSuccess(node: JsonNode) =
  doAssert node.hasKey("isError"), "Missing isError field"
  doAssert node["isError"].getBool() == false, "Expected success response: " & $node

proc assertContains(node: JsonNode, expected: string) =
  let text = node["content"][0]["text"].getStr()
  doAssert expected in text, "Expected '" & expected & "' in response: " & text

proc runHttpTransportTest() {.async.} =
  let tempDir = makeTempDir("opencontext7_http_")
  defer:
    cleanupDir(tempDir)

  var config = getDefaultConfig()
  config.server.host = "127.0.0.1"
  config.server.port = 18080
  config.server.transport = "http"
  config.security.enableAuth = false
  config.storage.dataDir = tempDir

  let manager = newLibraryManager(tempDir)
  setGlobalLibraryManager(manager)

  asyncCheck serveWithHTTP(config.server.host, config.server.port, config)
  await sleepAsync(200)

  let client = newAsyncHttpClient()
  defer:
    client.close()

  proc postTool(jsonBody: string): Future[JsonNode] {.async.} =
    client.headers = newHttpHeaders({"Content-Type": "application/json"})
    let response = await client.post(
      "http://" & config.server.host & ":" & $config.server.port & "/api/tools",
      jsonBody
    )
    return parseJson(await response.body)

  let registerBody = %*{
    "tool": "register_library",
    "arguments": {
      "name": "http-lib",
      "version": "1.0.0",
      "docs": "HTTP transport docs",
      "description": "HTTP mode test"
    }
  }
  let registerResult = await postTool($registerBody)
  assertSuccess(registerResult)

  let searchBody = %*{ "tool": "search_libraries", "arguments": {"query": "HTTP"} }
  let searchResult = await postTool($searchBody)
  assertSuccess(searchResult)
  assertContains(searchResult, "http-lib")

  let docsBody = %*{ "tool": "get_library_docs", "arguments": {"name": "http-lib"} }
  let docsResult = await postTool($docsBody)
  assertSuccess(docsResult)
  assertContains(docsResult, "HTTP transport docs")

  stopHttpServer()
  await sleepAsync(100)

proc readSseEvent(sock: AsyncSocket): Future[(string, string)] {.async.} =
  var eventName = ""
  var dataLines: seq[string] = @[]
  while true:
    let line = (await sock.recvLine()).strip()
    if line.len == 0:
      if eventName.len == 0 and dataLines.len == 0:
        continue
      return (eventName, dataLines.join("\n"))
    if line.startsWith(":"):
      continue
    if line.startsWith("event:"):
      eventName = line.split("event:")[1].strip()
    elif line.startsWith("data:"):
      dataLines.add(line.split("data:")[1].strip())
    else:
      dataLines.add(line)

proc runSseTransportTest() {.async.} =
  let tempDir = makeTempDir("opencontext7_sse_")
  defer:
    cleanupDir(tempDir)

  var config = getDefaultConfig()
  config.server.host = "127.0.0.1"
  config.server.port = 18081
  config.server.transport = "sse"
  config.security.enableAuth = false
  config.storage.dataDir = tempDir

  let manager = newLibraryManager(tempDir)
  setGlobalLibraryManager(manager)

  asyncCheck serveWithSSE(config.server.host, config.server.port, config)
  await sleepAsync(200)

  let socket = newAsyncSocket()
  await socket.connect(config.server.host, Port(config.server.port))
  let request = "GET /sse HTTP/1.1\r\n" &
                "Host: " & config.server.host & "\r\n" &
                "Accept: text/event-stream\r\n\r\n"
  await socket.send(request)

  # Read HTTP response headers
  while true:
    let headerLine = (await socket.recvLine()).strip()
    if headerLine.len == 0:
      break

  var sessionId = ""
  while sessionId.len == 0:
    let (eventName, data) = await readSseEvent(socket)
    if eventName == "session":
      sessionId = data

  let client = newAsyncHttpClient()
  defer:
    client.close()

  proc postMessage(body: JsonNode) {.async.} =
    client.headers = newHttpHeaders({
      "Content-Type": "application/json",
      "Mcp-Session-Id": sessionId
    })
    let response = await client.post(
      "http://" & config.server.host & ":" & $config.server.port & "/messages",
      $body
    )
    discard await response.body

  let registerBody = %*{
    "sessionId": sessionId,
    "tool": "register_library",
    "arguments": {
      "name": "sse-lib",
      "version": "1.0.0",
      "docs": "SSE transport docs",
      "description": "SSE mode test"
    }
  }
  await postMessage(registerBody)
  var (eventName, data) = await readSseEvent(socket)
  while eventName != "message":
    (eventName, data) = await readSseEvent(socket)
  var registerResult = parseJson(data)
  assertSuccess(registerResult)

  let searchBody = %*{
    "sessionId": sessionId,
    "tool": "search_libraries",
    "arguments": {"query": "SSE"}
  }
  await postMessage(searchBody)
  (eventName, data) = await readSseEvent(socket)
  while eventName != "message":
    (eventName, data) = await readSseEvent(socket)
  let searchResult = parseJson(data)
  assertSuccess(searchResult)
  assertContains(searchResult, "sse-lib")

  let docsBody = %*{
    "sessionId": sessionId,
    "tool": "get_library_docs",
    "arguments": {"name": "sse-lib"}
  }
  await postMessage(docsBody)
  (eventName, data) = await readSseEvent(socket)
  while eventName != "message":
    (eventName, data) = await readSseEvent(socket)
  let docsResult = parseJson(data)
  assertSuccess(docsResult)
  assertContains(docsResult, "SSE transport docs")

  socket.close()
  await sleepAsync(200)
  stopSseServer()
  await sleepAsync(100)

suite "Transport mode tool tests":
  test "STDIO tools":
    let tempDir = makeTempDir("opencontext7_stdio_")
    defer:
      cleanupDir(tempDir)
    let manager = newLibraryManager(tempDir)
    setGlobalLibraryManager(manager)

    let registerResult = handleRegisterLibrary("stdio-lib", "1.0.0", "STDIO docs", "stdio")
    assertSuccess(registerResult)

    let searchResult = handleSearchLibraries("stdio")
    assertSuccess(searchResult)
    assertContains(searchResult, "stdio-lib")

    let docsResult = handleGetLibraryDocs("stdio-lib")
    assertSuccess(docsResult)
    assertContains(docsResult, "STDIO docs")

  test "HTTP transport tools":
    waitFor runHttpTransportTest()

  test "SSE transport tools":
    waitFor runSseTransportTest()
