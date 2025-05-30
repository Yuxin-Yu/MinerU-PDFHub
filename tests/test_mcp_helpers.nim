##[
  Comprehensive tests for MCP Helpers - 100% coverage
]##

import unittest, json, strutils
import ../src/mcp_helpers

suite "MCP Helpers Comprehensive Tests":

  test "Create tool success result with simple text":
    let result = createToolSuccessResult("Operation completed successfully")
    
    check result.kind == JObject
    check result.hasKey("content")
    check result.hasKey("isError")
    
    let content = result["content"]
    check content.kind == JArray
    check content.len == 1
    
    let textItem = content[0]
    check textItem.hasKey("type")
    check textItem.hasKey("text")
    check textItem["type"].getStr() == "text"
    check textItem["text"].getStr() == "Operation completed successfully"
    
    check result["isError"].getBool() == false

  test "Create tool success result with empty string":
    let result = createToolSuccessResult("")
    
    let content = result["content"]
    let textItem = content[0]
    check textItem["text"].getStr() == ""
    check result["isError"].getBool() == false

  test "Create tool success result with multiline text":
    let multilineText = "Line 1\nLine 2\nLine 3"
    let result = createToolSuccessResult(multilineText)
    
    let content = result["content"]
    let textItem = content[0]
    check textItem["text"].getStr() == multilineText
    check result["isError"].getBool() == false

  test "Create tool success result with special characters":
    let specialText = "Special chars: !@#$%^&*()_+{}|:<>?[]\\;'\",./"
    let result = createToolSuccessResult(specialText)
    
    let content = result["content"]
    let textItem = content[0]
    check textItem["text"].getStr() == specialText
    check result["isError"].getBool() == false

  test "Create tool success result with unicode characters":
    let unicodeText = "Unicode: こんにちは 🚀 πάθοςμάθηση ñáéíóú"
    let result = createToolSuccessResult(unicodeText)
    
    let content = result["content"]
    let textItem = content[0]
    check textItem["text"].getStr() == unicodeText
    check result["isError"].getBool() == false

  test "Create tool success result with very long text":
    let longText = "Long text: " & "x".repeat(10000)
    let result = createToolSuccessResult(longText)
    
    let content = result["content"]
    let textItem = content[0]
    check textItem["text"].getStr() == longText
    check result["isError"].getBool() == false

  test "Create tool success result with JSON-like text":
    let jsonLikeText = """{"key": "value", "number": 42, "array": [1, 2, 3]}"""
    let result = createToolSuccessResult(jsonLikeText)
    
    let content = result["content"]
    let textItem = content[0]
    check textItem["text"].getStr() == jsonLikeText
    check result["isError"].getBool() == false

  test "Create tool error result with simple error message":
    let result = createToolErrorResult("File not found")
    
    check result.kind == JObject
    check result.hasKey("content")
    check result.hasKey("isError")
    
    let content = result["content"]
    check content.kind == JArray
    check content.len == 1
    
    let textItem = content[0]
    check textItem.hasKey("type")
    check textItem.hasKey("text")
    check textItem["type"].getStr() == "text"
    check textItem["text"].getStr() == "Error: File not found"
    
    check result["isError"].getBool() == true

  test "Create tool error result with empty error message":
    let result = createToolErrorResult("")
    
    let content = result["content"]
    let textItem = content[0]
    check textItem["text"].getStr() == "Error: "
    check result["isError"].getBool() == true

  test "Create tool error result with multiline error":
    let multilineError = "Connection failed\nTimeout occurred\nRetry limit exceeded"
    let result = createToolErrorResult(multilineError)
    
    let content = result["content"]
    let textItem = content[0]
    check textItem["text"].getStr() == "Error: " & multilineError
    check result["isError"].getBool() == true

  test "Create tool error result with special characters":
    let specialError = "Parse error: unexpected character '@' at position 15"
    let result = createToolErrorResult(specialError)
    
    let content = result["content"]
    let textItem = content[0]
    check textItem["text"].getStr() == "Error: " & specialError
    check result["isError"].getBool() == true

  test "Create tool error result with unicode characters":
    let unicodeError = "エラー: ファイルが見つかりません"
    let result = createToolErrorResult(unicodeError)
    
    let content = result["content"]
    let textItem = content[0]
    check textItem["text"].getStr() == "Error: " & unicodeError
    check result["isError"].getBool() == true

  test "Create tool error result with very long error message":
    let longError = "Very long error message: " & "x".repeat(5000)
    let result = createToolErrorResult(longError)
    
    let content = result["content"]
    let textItem = content[0]
    check textItem["text"].getStr() == "Error: " & longError
    check result["isError"].getBool() == true

  test "Compare success and error result structures":
    let successResult = createToolSuccessResult("Success message")
    let errorResult = createToolErrorResult("Error message")
    
    # Both should have the same structure
    check successResult.hasKey("content")
    check successResult.hasKey("isError")
    check errorResult.hasKey("content")
    check errorResult.hasKey("isError")
    
    # Content arrays should have same structure
    let successContent = successResult["content"][0]
    let errorContent = errorResult["content"][0]
    
    check successContent.hasKey("type")
    check successContent.hasKey("text")
    check errorContent.hasKey("type")
    check errorContent.hasKey("text")
    
    check successContent["type"].getStr() == "text"
    check errorContent["type"].getStr() == "text"
    
    # Only isError flag should be different
    check successResult["isError"].getBool() == false
    check errorResult["isError"].getBool() == true

  test "Verify JSON structure compatibility":
    let result = createToolSuccessResult("Test")
    
    # Verify the result can be serialized back to JSON string
    let jsonString = $result
    check jsonString.len > 0
    
    # Verify it can be parsed back
    let parsed = parseJson(jsonString)
    check parsed.hasKey("content")
    check parsed.hasKey("isError")

  test "Create tool results with control characters":
    let controlChars = "\t\n\r\x00\x1F"
    
    let successResult = createToolSuccessResult(controlChars)
    let errorResult = createToolErrorResult(controlChars)
    
    # Should handle control characters without crashing
    check successResult["content"][0]["text"].getStr() == controlChars
    check errorResult["content"][0]["text"].getStr() == "Error: " & controlChars

  test "Memory efficiency with large texts":
    # Test that creating multiple large results doesn't cause memory issues
    let largeText = "Large text: " & "Lorem ipsum ".repeat(1000)
    
    var results: seq[JsonNode] = @[]
    for i in 0..<100:
      results.add(createToolSuccessResult(largeText & $i))
      results.add(createToolErrorResult(largeText & $i))
    
    # Verify all results were created correctly
    check results.len == 200
    for i, result in results:
      check result.hasKey("content")
      check result.hasKey("isError")

  test "Null and special string handling":
    # Test various edge case strings
    let testCases = [
      "null",
      "undefined", 
      "true",
      "false",
      "0",
      "[]",
      "{}",
      "\"quoted string\"",
      "'single quoted'",
      "`backticks`"
    ]
    
    for testCase in testCases:
      let successResult = createToolSuccessResult(testCase)
      let errorResult = createToolErrorResult(testCase)
      
      check successResult["content"][0]["text"].getStr() == testCase
      check errorResult["content"][0]["text"].getStr() == "Error: " & testCase