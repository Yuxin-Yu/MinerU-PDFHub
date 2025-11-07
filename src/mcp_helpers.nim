##[
  MCP Helper functions for tool responses
  MCP 工具响应辅助：生成统一的成功/错误 JSON 结构
]##

import std/json

## 构造成功响应，content 为最终展示文本
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

## 构造错误响应，在文本前自动添加 Error 前缀
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
