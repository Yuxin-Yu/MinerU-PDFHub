##[
  Context7 Local - On-premises MCP server for private library documentation
  
  This server provides MCP (Model Context Protocol) interface for managing
  and serving documentation of private/internal libraries.
]##

import std/[asyncdispatch, json, strutils, tables, os, logging, times, options]
# Use stub for now due to MCP SDK import issues
import mcp_stub
import library_manager, config_manager, cli, mcp_helpers

const VERSION = "1.0.0"

type
  Context7LocalServer* = ref object
    server: Server
    libraryManager: LibraryManager
    config: Config

proc newContext7LocalServer*(): Context7LocalServer =
  let config = loadConfig()
  let libraryManager = newLibraryManager(config.storage.dataDir)
  
  let serverInfo = Implementation(
    name: "context7local",
    version: VERSION
  )
  
  let capabilities = ServerCapabilities(
    resources: some(ResourcesCapability()),
    tools: some(ToolsCapability())
  )
  
  let server = newServer(serverInfo, capabilities)
  
  result = Context7LocalServer(
    server: server,
    libraryManager: libraryManager,
    config: config
  )

proc setupTools(ctx: Context7LocalServer) {.async.} =
  # Tool: Register a new library
  proc registerLibraryHandler(args: JsonNode): Future[JsonNode] {.async.} =
    try:
      let name = args["name"].getStr()
      let version = args["version"].getStr()
      let docs = args["docs"].getStr()
      let description = args.getOrDefault("description").getStr("")
      
      let library = Library(
        name: name,
        version: version,
        description: description,
        docs: docs,
        registeredAt: now()
      )
      
      await ctx.libraryManager.registerLibrary(library)
      return createToolSuccessResult("Library registered successfully: " & name & "@" & version)
    except Exception as e:
      return createToolErrorResult("Failed to register library: " & e.msg)
  
  ctx.server.registerToolHandler(
    "register_library",
    some("Register a new library with documentation"),
    %*{
      "type": "object",
      "properties": {
        "name": {"type": "string", "description": "Library name"},
        "version": {"type": "string", "description": "Library version"},
        "docs": {"type": "string", "description": "Documentation content"},
        "description": {"type": "string", "description": "Library description (optional)"}
      },
      "required": ["name", "version", "docs"]
    },
    registerLibraryHandler
  )
  
  # Tool: Search libraries
  proc searchLibrariesHandler(args: JsonNode): Future[JsonNode] {.async.} =
    try:
      let query = args["query"].getStr()
      let libraries = await ctx.libraryManager.searchLibraries(query)
      
      var results = newJArray()
      for lib in libraries:
        results.add(%*{
          "name": lib.name,
          "version": lib.version,
          "description": lib.description,
          "registeredAt": lib.registeredAt.format("yyyy-MM-dd'T'HH:mm:ss")
        })
      
      return createToolSuccessResult($results)
    except Exception as e:
      return createToolErrorResult("Failed to search libraries: " & e.msg)
  
  ctx.server.registerToolHandler(
    "search_libraries",
    some("Search for libraries by name or description"),
    %*{
      "type": "object",
      "properties": {
        "query": {"type": "string", "description": "Search query"}
      },
      "required": ["query"]
    },
    searchLibrariesHandler
  )
  
  # Tool: Get library documentation
  proc getLibraryDocsHandler(args: JsonNode): Future[JsonNode] {.async.} =
    try:
      let name = args["name"].getStr()
      let version = args.getOrDefault("version").getStr("latest")
      
      let library = await ctx.libraryManager.getLibrary(name, version)
      if library.isNone():
        return createToolErrorResult("Library not found: " & name & "@" & version)
      
      return createToolSuccessResult(library.get().docs)
    except Exception as e:
      return createToolErrorResult("Failed to get library docs: " & e.msg)
  
  ctx.server.registerToolHandler(
    "get_library_docs",
    some("Get documentation for a specific library"),
    %*{
      "type": "object",
      "properties": {
        "name": {"type": "string", "description": "Library name"},
        "version": {"type": "string", "description": "Library version (default: latest)"}
      },
      "required": ["name"]
    },
    getLibraryDocsHandler
  )

proc setupResources(ctx: Context7LocalServer) {.async.} =
  # Add basic info resource
  ctx.server.addTextResource(
    "context7local://info",
    "Context7 Local Server Info",
    "Context7 Local MCP Server v" & VERSION & "\nManaging " & 
    $(await ctx.libraryManager.getLibraryCount()) & " libraries",
    description = some("Server information and statistics"),
    mimeType = some("text/plain")
  )

proc main() {.async.} =
  addHandler(newConsoleLogger(lvlInfo))
  info "Starting Context7 Local MCP Server v" & VERSION
  
  let ctx = newContext7LocalServer()
  
  await ctx.setupTools()
  await ctx.setupResources()
  
  let transport = newStdioTransport()
  await ctx.server.connect(transport)
  
  info "Context7 Local server started and listening..."
  
  # Keep server running
  while true:
    await sleepAsync(1000)

when isMainModule:
  # Check if running as MCP server or CLI
  let args = commandLineParams()
  if args.len > 0 and args[0] != "server":
    # Run as CLI
    waitFor parseCLI()
  else:
    # Run as MCP server
    waitFor main()