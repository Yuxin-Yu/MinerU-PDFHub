##[
  MinerU-PDFHub - On-premises MCP server for private library documentation
  
  This server provides MCP (Model Context Protocol) interface for managing
  and serving documentation of private/internal libraries.
  
  Enhanced with HTTP and SSE transport mode support.
]##

import std/[asyncdispatch, json, strutils, tables, os, logging, times, options]
import nimcp
import nimcp/auth  # Import AuthConfig type
import library_manager, config_manager, cli, mcp_helpers

const VERSION = "1.0.0"

# Create the MCP server using the macro API with simple, GC-safe operations
let server = mcpServer("mineru-pdfhub", VERSION):
  
  mcpTool:
    proc register_library(name: string, version: string, docs: string, description: string = ""): string {.gcsafe.} =
      ## Register a new library with documentation
      ## - name: Library name
      ## - version: Library version
      ## - docs: Documentation content
      ## - description: Library description (optional)
      return "Library registered successfully: " & name & "@" & version
  
  mcpTool:
    proc search_libraries(query: string): string {.gcsafe.} =
      ## Search for libraries by name or description
      ## - query: Search query
      return "Found 1 library matching: " & query
  
  mcpTool:
    proc get_library_docs(name: string, version: string = "latest", max_characters: int = 5000, topic: string = "", topic_match: string = "literal"): string {.gcsafe.} =
      ## Get documentation for a specific library
      ## - name: Library name
      ## - version: Library version (default: latest)
      ## - max_characters: Maximum number of characters to return (default: 5000)
      ## - topic: Optional comma-separated list of up to 5 topic keywords (highest priority first)
      ## - topic_match: Optional knowledge-graph alignment algorithm
      var response = "Documentation for " & name & "@" & version
      if topic.len > 0:
        response &= " filtered by topics: " & topic
      if topic_match.len > 0:
        response &= " using " & topic_match & " matcher"
      response &= ":\n\nThis is sample documentation content."
      if max_characters > 0 and response.len > max_characters:
        response = response[0 ..< max_characters]
      return response

proc serveWithStdio() {.async.} =
  ## Serve using stdio transport (default)
  info "Starting MinerU-PDFHub MCP Server with stdio transport"
  let transport = newStdioTransport()
  transport.serve(server)

proc serveWithHTTP(host: string, port: int, authConfig: AuthConfig = newAuthConfig()) {.async.} =
  ## Serve using HTTP transport
  info "Starting MinerU-PDFHub MCP Server with HTTP transport on " & host & ":" & $port
  let transport = newMummyTransport(port = port, host = host, authConfig = authConfig)
  transport.serve(server)

proc serveWithSSE(host: string, port: int, authConfig: AuthConfig = newAuthConfig()) {.async.} =
  ## Serve using SSE transport
  info "Starting MinerU-PDFHub MCP Server with SSE transport on " & host & ":" & $port
  let transport = newSseTransport(port = port, host = host, authConfig = authConfig)
  transport.serve(server)

proc main() {.async.} =
  addHandler(newConsoleLogger(lvlInfo))
  info "Starting MinerU-PDFHub MCP Server v" & VERSION
  
  # Load configuration
  let config = loadConfig()
  
  # Start server based on configured transport mode
  case config.server.transport
  of "stdio":
    info "Using stdio transport mode"
    await serveWithStdio()
  of "http":
    info "Using HTTP transport mode on " & config.server.host & ":" & $config.server.port
    let authConfig = if config.security.enableAuth and config.security.apiKeys.len > 0:
                      # Create a token validator function
                      let expectedToken = config.security.apiKeys[0]
                      proc validateToken(token: string): bool {.gcsafe.} =
                        return token == expectedToken
                      newAuthConfig(validateToken)
                    else:
                      newAuthConfig()
    await serveWithHTTP(config.server.host, config.server.port, authConfig)
  of "sse":
    info "Using SSE transport mode on " & config.server.host & ":" & $config.server.port
    let authConfig = if config.security.enableAuth and config.security.apiKeys.len > 0:
                      # Create a token validator function
                      let expectedToken = config.security.apiKeys[0]
                      proc validateToken(token: string): bool {.gcsafe.} =
                        return token == expectedToken
                      newAuthConfig(validateToken)
                    else:
                      newAuthConfig()
    await serveWithSSE(config.server.host, config.server.port, authConfig)
  else:
    error "Unknown transport mode: " & config.server.transport
    error "Falling back to stdio transport mode"
    await serveWithStdio()

when isMainModule:
  # Check if running as MCP server or CLI
  let args = commandLineParams()
  if args.len > 0 and args[0] != "server":
    # Run as CLI
    waitFor parseCLI()
  else:
    # Run as MCP server
    waitFor main()
