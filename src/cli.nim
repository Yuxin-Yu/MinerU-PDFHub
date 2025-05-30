##[
  CLI Interface - Command line interface for Context7 Local
]##

import std/[os, strutils, parseopt, asyncdispatch, json, times, options]
import library_manager, config_manager

const 
  VERSION = "1.0.0"
  USAGE = """
Context7 Local v""" & VERSION & """

Usage:
  context7local server                    Start the MCP server
  context7local register <name> <version> <docs_file>  Register a library
  context7local search <query>            Search for libraries
  context7local get <name> [version]      Get library documentation
  context7local list                      List all libraries
  context7local delete <name> [version]   Delete a library
  context7local config                    Show configuration
  context7local init                      Initialize configuration

Options:
  -h, --help        Show this help
  -v, --version     Show version
  --config=PATH     Use custom config file
  --data-dir=PATH   Use custom data directory
"""

proc showUsage*() =
  echo USAGE

proc showVersion*() =
  echo "Context7 Local v" & VERSION

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

proc initConfig(configPath: string = "") =
  let config = getDefaultConfig()
  let path = if configPath == "": getConfigPath() else: configPath
  saveConfig(config, path)
  echo "Configuration initialized at: ", path
  showConfig(path)

proc registerLibrary*(name, version, docsFile: string, dataDir: string = "") {.async.} =
  if not fileExists(docsFile):
    echo "Error: Documentation file not found: ", docsFile
    quit(1)
  
  let docs = readFile(docsFile)
  let manager = newLibraryManager(
    if dataDir == "": loadConfig().storage.dataDir else: dataDir
  )
  
  let library = Library(
    name: name,
    version: version,
    description: "Library registered via CLI",
    docs: docs,
    tags: @[],
    registeredAt: now(),
    lastUpdated: now()
  )
  
  await manager.registerLibrary(library)
  echo "Library registered: ", name, "@", version

proc searchLibraries*(query: string, dataDir: string = "") {.async.} =
  let manager = newLibraryManager(
    if dataDir == "": loadConfig().storage.dataDir else: dataDir
  )
  
  let results = await manager.searchLibraries(query)
  
  if results.len == 0:
    echo "No libraries found matching: ", query
  else:
    echo "Found ", results.len, " libraries:"
    for lib in results:
      echo "  ", lib.name, "@", lib.version, " - ", lib.description

proc getLibraryDocs*(name: string, version: string = "latest", dataDir: string = "") {.async.} =
  let manager = newLibraryManager(
    if dataDir == "": loadConfig().storage.dataDir else: dataDir
  )
  
  let library = await manager.getLibrary(name, version)
  
  if library.isNone():
    echo "Library not found: ", name, "@", version
    quit(1)
  
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
      echo "  ", lib.name, "@", lib.version, " (", lib.registeredAt.format("yyyy-MM-dd"), ")"

proc deleteLibrary*(name: string, version: string = "", dataDir: string = "") {.async.} =
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
  echo "Starting Context7 Local MCP Server..."
  # This would normally import and run the main server
  # For now, just show that it would start
  echo "Server would start here with config: ", if configPath == "": getConfigPath() else: configPath
  echo "Use 'nim c -r src/context7local.nim' to actually run the server"

proc parseCLI*() {.async.} =
  var
    configPath = ""
    dataDir = ""
  
  # Parse options first
  var p = initOptParser()
  for kind, key, val in p.getopt():
    case kind
    of cmdArgument:
      discard  # Will handle arguments later
    of cmdLongOption, cmdShortOption:
      case key
      of "help", "h":
        showUsage()
        quit(0)
      of "version", "v":
        showVersion()
        quit(0)
      of "config":
        configPath = val
      of "data-dir":
        dataDir = val
      else:
        echo "Unknown option: ", key
        quit(1)
    of cmdEnd:
      break
  
  # Parse command and arguments
  let args = commandLineParams()
  if args.len == 0:
    showUsage()
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
  of "search":
    if args.len < 2:
      echo "Error: search requires a query"
      quit(1)
    await searchLibraries(args[1], dataDir)
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
  waitFor parseCLI()