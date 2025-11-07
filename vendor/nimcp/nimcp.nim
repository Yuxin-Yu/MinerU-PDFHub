## NimCP - Easy Model Context Protocol (MCP) server implementation for Nim
## 
## This module provides a high-level, macro-based API for creating MCP servers
## that integrate seamlessly with LLM applications.

import nimcp/[types, protocol, server, mcpmacros, stdio_transport, context, schema, resource_templates, logging]

export types, server, protocol, stdio_transport, context, schema, resource_templates, logging
export mcpmacros.mcpServer, mcpmacros.mcpTool, mcpmacros.mcpResource, mcpmacros.mcpPrompt