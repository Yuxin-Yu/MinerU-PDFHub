# Stub MCP types for testing when MCP SDK is not available
import std/[json, asyncdispatch, tables, options]

type
  MCPServer* = ref object
    name*: string
    version*: string
  
  Server* = MCPServer  # Alias for compatibility
    
  MCPTool* = object
    name*: string
    description*: string
    inputSchema*: JsonNode
    
  MCPResource* = object
    uri*: string
    name*: string
    description*: string
    
  MCPRequest* = object
    id*: string
    `method`*: string
    params*: JsonNode
    
  MCPResponse* = object
    id*: string
    result*: JsonNode
    error*: JsonNode
    
  MCPTransport* = ref object of RootObj
    
  StdioTransport* = ref object of MCPTransport
  
  Implementation* = object
    name*: string
    version*: string
    
  ResourcesCapability* = object
    subscribe*: bool
    listChanged*: bool
    
  ServerCapabilities* = object
    tools*: Option[ToolsCapability]
    resources*: Option[ResourcesCapability]
    
  ServerInfo* = object
    name*: string
    version*: string
    
  ToolCall* = object
    name*: string
    arguments*: JsonNode
    
  ToolsCapability* = object
    listChanged*: bool

proc newMCPServer*(name, version: string): MCPServer =
  MCPServer(name: name, version: version)
  
proc registerTool*(server: MCPServer, tool: MCPTool) = 
  discard
  
proc registerResource*(server: MCPServer, resource: MCPResource) =
  discard
  
proc newStdioTransport*(): StdioTransport =
  new(result)
  
proc newServer*(info: Implementation): MCPServer =
  MCPServer(name: info.name, version: info.version)

proc newServer*(info: Implementation, capabilities: ServerCapabilities): MCPServer =
  MCPServer(name: info.name, version: info.version)

proc newServerCapabilities*(): ServerCapabilities =
  ServerCapabilities(
    tools: some(ToolsCapability(listChanged: false)),
    resources: some(ResourcesCapability(subscribe: false, listChanged: false))
  )

proc registerToolHandler*(server: MCPServer, name: string, description: Option[string], schema: JsonNode, handler: proc): auto =
  # Stub - do nothing
  discard

proc addTextResource*(server: MCPServer, uri: string, name: string, text: string, description: Option[string] = none(string), mimeType: Option[string] = none(string)): auto =
  # Stub - do nothing
  discard

# createToolSuccessResult and createToolErrorResult are in mcp_helpers.nim

proc connect*(server: MCPServer, transport: MCPTransport) {.async.} =
  # Stub - do nothing for connection
  discard

proc start*(server: MCPServer, transport: MCPTransport) {.async.} =
  # Stub - just wait forever
  await sleepAsync(1000000)