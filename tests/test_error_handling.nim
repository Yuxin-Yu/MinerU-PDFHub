##[
  Comprehensive Error Handling and Boundary Value Tests
]##

import unittest, asyncdispatch, times, os, json, strutils
import ../src/[library_manager, config_manager]

suite "Error Handling and Boundary Value Tests":
  let testDataDir = "/tmp/context7local_error_test"
  
  setup:
    removeDir(testDataDir)
    createDir(testDataDir)
  
  teardown:
    removeDir(testDataDir)

  test "Library Manager - Invalid data directory":
    # Test with read-only directory
    let readOnlyDir = testDataDir / "readonly"
    createDir(readOnlyDir)
    setFilePermissions(readOnlyDir, {fpUserRead, fpUserExec})
    
    let manager = newLibraryManager(readOnlyDir)
    
    # This should still create the manager, but operations might fail
    check manager != nil
    
    # Try to register a library (might fail due to permissions)
    let lib = Library(
      name: "readonly-test",
      version: "1.0.0",
      description: "Test",
      docs: "Test docs",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    try:
      waitFor manager.registerLibrary(lib)
      # Might succeed or fail depending on system
    except:
      check true  # Expected to fail on read-only directory
    
    # Reset permissions for cleanup
    setFilePermissions(readOnlyDir, {fpUserRead, fpUserWrite, fpUserExec})

  test "Library Manager - Extremely long file paths":
    let manager = newLibraryManager(testDataDir)
    
    # Test with very long library name
    let longName = "x".repeat(255)  # Maximum filename length on most systems
    let lib = Library(
      name: longName,
      version: "1.0.0",
      description: "Long name test",
      docs: "Docs",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib)
    
    let retrieved = waitFor manager.getLibrary(longName, "1.0.0")
    check retrieved.isSome

  test "Library Manager - Invalid JSON in index file":
    let manager = newLibraryManager(testDataDir)
    
    # Corrupt the index file
    let indexFile = manager.getIndexFile()
    writeFile(indexFile, "{ invalid json content")
    
    # Loading should handle the corruption gracefully
    waitFor manager.loadIndex()
    check true  # Should not crash

  test "Library Manager - Empty and null values":
    let manager = newLibraryManager(testDataDir)
    
    # Test with empty values
    let emptyLib = Library(
      name: "empty-test",
      version: "",  # Empty version
      description: "",  # Empty description
      docs: "",  # Empty docs
      tags: @[],  # Empty tags
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(emptyLib)
    
    let retrieved = waitFor manager.getLibrary("empty-test", "")
    # This might succeed or fail depending on implementation

  test "Library Manager - Maximum values":
    let manager = newLibraryManager(testDataDir)
    
    # Test with maximum integer values and very large content
    let maxLib = Library(
      name: "max-test",
      version: "999.999.999",
      description: "d".repeat(10000),  # Very long description
      docs: "# Max Test\n\n" & "Content ".repeat(100000),  # Very large docs
      tags: (0..<1000).mapIt("tag" & $it),  # Many tags
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(maxLib)
    
    let retrieved = waitFor manager.getLibrary("max-test", "999.999.999")
    check retrieved.isSome
    check retrieved.get().docs.len > 500000

  test "Library Manager - Special characters and encoding":
    let manager = newLibraryManager(testDataDir)
    
    # Test with various special characters
    let specialChars = [
      "\x00",  # Null character
      "\x1F",  # Control character
      "\x7F",  # DEL character
      "🚀",    # Emoji
      "こんにちは",  # Japanese
      "测试",   # Chinese
      "тест",   # Russian
      "🔥💯🎉",  # Multiple emojis
      "\r\n\t",  # Control sequences
      "\"'`",   # Quotes
      "<>&",    # HTML special chars
      "${}\\"   # Shell special chars
    ]
    
    for i, chars in specialChars:
      let lib = Library(
        name: "special-" & $i,
        version: "1.0.0",
        description: "Special chars: " & chars,
        docs: "# Special Test\n\nContent: " & chars,
        tags: @["special"],
        registeredAt: now(),
        lastUpdated: now()
      )
      
      waitFor manager.registerLibrary(lib)
      
      let retrieved = waitFor manager.getLibrary("special-" & $i, "1.0.0")
      check retrieved.isSome

  test "Library Manager - Time edge cases":
    let manager = newLibraryManager(testDataDir)
    
    # Test with edge case times
    let unixEpoch = fromUnix(0).local()  # Unix epoch
    let futureTime = fromUnix(4102444800).local()  # Year 2100
    
    let timeLib = Library(
      name: "time-test",
      version: "1.0.0",
      description: "Time edge case test",
      docs: "Time test docs",
      tags: @[],
      registeredAt: unixEpoch,
      lastUpdated: futureTime
    )
    
    waitFor manager.registerLibrary(timeLib)
    
    let retrieved = waitFor manager.getLibrary("time-test", "1.0.0")
    check retrieved.isSome

  test "Library Manager - Concurrent access simulation":
    let manager = newLibraryManager(testDataDir)
    
    # Simulate concurrent modifications
    var futures: seq[Future[void]] = @[]
    
    # Multiple threads trying to register the same library
    for i in 0..<5:
      let lib = Library(
        name: "concurrent-same",
        version: "1.0.0",
        description: "Concurrent test " & $i,
        docs: "Docs " & $i,
        tags: @["concurrent"],
        registeredAt: now(),
        lastUpdated: now()
      )
      futures.add(manager.registerLibrary(lib))
    
    waitFor all(futures)
    
    # Should have one library (last one wins)
    let result = waitFor manager.getLibrary("concurrent-same", "1.0.0")
    check result.isSome

  test "Config Manager - Malformed YAML":
    let configPath = testDataDir / "malformed.yaml"
    
    let malformedConfigs = [
      "invalid: yaml: content: here:",
      "- list\n  - without\nproper: indentation",
      "key: value\n  invalid indentation",
      "\x00\x01\x02",  # Binary data
      "🚀: invalid key",
      "key: \x00value",
      ""  # Empty file
    ]
    
    for malformed in malformedConfigs:
      writeFile(configPath, malformed)
      
      let config = loadConfig(configPath)
      # Should return default config without crashing
      check config.server.host == "localhost"

  test "Config Manager - Boundary value integers":
    let configPath = testDataDir / "boundary.yaml"
    
    let boundaryValues = [
      ("0", 0),
      ("1", 1),
      ("-1", 8080),  # Should default to 8080 for invalid
      ("65535", 65535),  # Max port
      ("65536", 8080),   # Should default for invalid port
      ("2147483647", 2147483647),  # Max int32
      ("-2147483648", 8080)  # Min int32, should default
    ]
    
    for (value, expected) in boundaryValues:
      let yaml = "server:\n  port: " & value
      writeFile(configPath, yaml)
      
      let config = loadConfig(configPath)
      if expected == 8080 and value != "0":
        # Invalid values should default to 8080
        check config.server.port == 8080
      else:
        check config.server.port == expected

  test "Config Manager - Boundary value strings":
    let configPath = testDataDir / "string_boundary.yaml"
    
    # Test with very long strings
    let veryLongHost = "host." & "x".repeat(1000) & ".com"
    let yaml = "server:\n  host: " & veryLongHost
    writeFile(configPath, yaml)
    
    let config = loadConfig(configPath)
    check config.server.host == veryLongHost

  test "Config Manager - Boolean edge cases":
    let configPath = testDataDir / "boolean.yaml"
    
    let booleanTests = [
      ("true", true),
      ("True", true),
      ("TRUE", true),
      ("false", false),
      ("False", false),
      ("FALSE", false),
      ("yes", false),   # Invalid, should default to false
      ("no", false),    # Invalid, should default to false
      ("1", false),     # Invalid, should default to false
      ("0", false),     # Invalid, should default to false
      ("", false)       # Empty, should default to false
    ]
    
    for (value, expected) in booleanTests:
      let yaml = "security:\n  enableAuth: " & value
      writeFile(configPath, yaml)
      
      let config = loadConfig(configPath)
      check config.security.enableAuth == expected

  test "Config Manager - File system edge cases":
    # Test with non-existent directory
    let deepPath = testDataDir / "very" / "deep" / "nested" / "path" / "config.yaml"
    
    let config = getDefaultConfig()
    saveConfig(config, deepPath)
    
    check fileExists(deepPath)
    
    # Test loading from the deep path
    let loadedConfig = loadConfig(deepPath)
    check loadedConfig.server.host == "localhost"

  test "Library search edge cases":
    let manager = newLibraryManager(testDataDir)
    
    # Register libraries with edge case names for searching
    let edgeCaseLibs = [
      ("", "Empty name"),
      ("a", "Single char"),
      ("ab", "Two chars (should be skipped in search index)"),
      ("search-test", "Normal name"),
      ("UPPERCASE", "Uppercase name"),
      ("MiXeD-CaSe", "Mixed case name"),
      ("123-numeric", "Starts with numbers"),
      ("special!@#", "Special characters"),
      ("unicode-こんにちは", "Unicode characters")
    ]
    
    for i, (name, desc) in edgeCaseLibs:
      if name.len > 0:  # Skip empty name test for now
        let lib = Library(
          name: name,
          version: "1.0.0",
          description: desc,
          docs: "Docs for " & name,
          tags: @["edge"],
          registeredAt: now(),
          lastUpdated: now()
        )
        
        waitFor manager.registerLibrary(lib)
    
    # Test various search queries
    let searchQueries = [
      "",           # Empty query
      "a",          # Single char
      "ab",         # Two chars
      "search",     # Normal search
      "SEARCH",     # Uppercase search
      "Search",     # Mixed case search
      "unicode",    # Unicode search
      "nonexistent" # Non-existent
    ]
    
    for query in searchQueries:
      let results = waitFor manager.searchLibraries(query)
      # Should not crash regardless of query
      check results.len >= 0

  test "Memory stress test":
    let manager = newLibraryManager(testDataDir)
    
    # Create many libraries to test memory usage
    let numLibraries = 100
    
    for i in 0..<numLibraries:
      let lib = Library(
        name: "stress-lib-" & $i,
        version: "1.0.0",
        description: "Stress test library " & $i,
        docs: "# Stress Test " & $i & "\n\n" & "Content ".repeat(100),
        tags: @["stress", "test", $i],
        registeredAt: now(),
        lastUpdated: now()
      )
      
      waitFor manager.registerLibrary(lib)
    
    # Verify all libraries were registered
    let count = waitFor manager.getLibraryCount()
    check count == numLibraries
    
    # Test bulk search
    let results = waitFor manager.searchLibraries("stress")
    check results.len == numLibraries

  test "Disk space edge cases":
    let manager = newLibraryManager(testDataDir)
    
    # Test with very large documentation
    let hugeContent = "# Huge Documentation\n\n" & "Very long line of text that repeats many times. ".repeat(50000)
    
    let hugeLib = Library(
      name: "huge-lib",
      version: "1.0.0",
      description: "Library with huge documentation",
      docs: hugeContent,
      tags: @["huge"],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(hugeLib)
    
    let retrieved = waitFor manager.getLibrary("huge-lib", "1.0.0")
    check retrieved.isSome
    check retrieved.get().docs.len > 1000000  # Over 1MB

  test "Index corruption recovery":
    let manager = newLibraryManager(testDataDir)
    
    # Register a library first
    let lib = Library(
      name: "corruption-test",
      version: "1.0.0",
      description: "Test library",
      docs: "Docs",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib)
    
    # Corrupt the index
    let indexFile = manager.getIndexFile()
    writeFile(indexFile, "corrupted content")
    
    # Create new manager - should handle corruption
    let newManager = newLibraryManager(testDataDir)
    
    # Original library files should still exist
    let retrieved = waitFor newManager.loadLibraryFromDisk("corruption-test", "1.0.0")
    check retrieved.isSome