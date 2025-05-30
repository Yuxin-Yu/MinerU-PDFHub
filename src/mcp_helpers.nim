##[
  MCP Helper functions for tool responses
]##

import std/json

proc createToolSuccessResult*(content: string): JsonNode =
  return %*{
    "content": [
      {
        "type": "text",
        "text": content
      }
    ],
    "isError": false
  }

proc createToolErrorResult*(error: string): JsonNode =
  return %*{
    "content": [
      {
        "type": "text", 
        "text": "Error: " & error
      }
    ],
    "isError": true
  }