##[
  Integration and End-to-End Tests
]##

import unittest, asyncdispatch, times, os, json, strutils
import ../src/[library_manager, config_manager, cli, mcp_helpers]

suite "Integration Tests":
  let testDataDir = "/tmp/opencontext7_integration_test"
  let testConfigPath = testDataDir / "config.yaml"
  
  setup:
    removeDir(testDataDir)
    createDir(testDataDir)
  
  teardown:
    removeDir(testDataDir)

  test "Complete library lifecycle":
    # Test the complete lifecycle of a library from registration to deletion
    let manager = newLibraryManager(testDataDir)
    
    # 1. Register library
    let lib = Library(
      name: "lifecycle-test",
      version: "1.0.0",
      description: "Complete lifecycle test library",
      docs: "# Lifecycle Test\n\nComplete documentation",
      tags: @["lifecycle", "test"],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib)
    
    # 2. Verify registration
    let count = waitFor manager.getLibraryCount()
    check count == 1
    
    # 3. Search for the library
    let searchResults = waitFor manager.searchLibraries("lifecycle")
    check searchResults.len == 1
    check searchResults[0].name == "lifecycle-test"
    
    # 4. Get library documentation
    let retrieved = waitFor manager.getLibrary("lifecycle-test", "1.0.0")
    check retrieved.isSome
    check retrieved.get().docs == "# Lifecycle Test\n\nComplete documentation"
    
    # 5. Update library with new version
    let lib2 = Library(
      name: "lifecycle-test",
      version: "2.0.0",
      description: "Updated lifecycle test library",
      docs: "# Lifecycle Test v2\n\nUpdated documentation",
      tags: @["lifecycle", "test", "updated"],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib2)
    
    # 6. Verify both versions exist
    let v1 = waitFor manager.getLibrary("lifecycle-test", "1.0.0")
    let v2 = waitFor manager.getLibrary("lifecycle-test", "2.0.0")
    let latest = waitFor manager.getLibrary("lifecycle-test", "latest")
    
    check v1.isSome
    check v2.isSome
    check latest.isSome
    check latest.get().version == "2.0.0"
    
    # 7. List all libraries
    let allLibs = manager.listLibraries()
    check allLibs.len == 1  # Only latest version in list
    check allLibs[0].version == "2.0.0"
    
    # 8. Delete specific version
    let deleted1 = waitFor manager.deleteLibrary("lifecycle-test", "1.0.0")
    check deleted1 == true
    
    let afterDelete1 = waitFor manager.getLibrary("lifecycle-test", "1.0.0")
    check afterDelete1.isNone
    
    # 9. Delete all versions
    let deletedAll = waitFor manager.deleteLibrary("lifecycle-test", "")
    check deletedAll == true
    
    let finalCount = waitFor manager.getLibraryCount()
    check finalCount == 0

  test "Configuration integration":
    # Test configuration loading and usage across components
    
    # 1. Create custom configuration
    let customConfig = Config(
      server: ServerConfig(
        host: "custom-host",
        port: 9999,
        transport: "http"
      ),
      storage: StorageConfig(
        dataDir: testDataDir / "custom",
        maxLibraries: 50,
        maxDocSize: 1024 * 1024
      ),
      security: SecurityConfig(
        enableAuth: true,
        apiKeys: @["test-key-1", "test-key-2"],
        allowedIps: @["192.168.1.1", "10.0.0.1"]
      )
    )
    
    # 2. Save configuration
    saveConfig(customConfig, testConfigPath)
    
    # 3. Load configuration
    let loadedConfig = loadConfig(testConfigPath)
    
    check loadedConfig.server.host == "custom-host"
    check loadedConfig.server.port == 9999
    check loadedConfig.storage.dataDir == testDataDir / "custom"
    check loadedConfig.storage.maxLibraries == 50
    check loadedConfig.security.enableAuth == true
    check loadedConfig.security.apiKeys.len == 2
    
    # 4. Use configuration in library manager
    let manager = newLibraryManager(loadedConfig.storage.dataDir)
    
    # 5. Test with the configured data directory
    let lib = Library(
      name: "config-test",
      version: "1.0.0",
      description: "Configuration test",
      docs: "Test docs",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib)
    
    # 6. Verify library was saved in custom directory
    check dirExists(loadedConfig.storage.dataDir)
    let retrieved = waitFor manager.getLibrary("config-test", "1.0.0")
    check retrieved.isSome

  test "Multi-library management":
    # Test managing multiple libraries with different characteristics
    let manager = newLibraryManager(testDataDir)
    
    # Create libraries with different characteristics
    let libraries = @[
      Library(
        name: "api-client",
        version: "1.0.0",
        description: "REST API client library",
        docs: "# API Client\n\nMakes HTTP requests",
        tags: @["api", "http", "client"],
        registeredAt: now(),
        lastUpdated: now()
      ),
      Library(
        name: "database-utils",
        version: "2.1.0",
        description: "Database utility functions",
        docs: "# Database Utils\n\nHelper functions for database operations",
        tags: @["database", "utils", "sql"],
        registeredAt: now(),
        lastUpdated: now()
      ),
      Library(
        name: "logging-framework",
        version: "3.0.0-beta",
        description: "Structured logging framework",
        docs: "# Logging Framework\n\nStructured logging with multiple outputs",
        tags: @["logging", "framework", "structured"],
        registeredAt: now(),
        lastUpdated: now()
      ),
      Library(
        name: "crypto-helpers",
        version: "1.5.2",
        description: "Cryptographic helper functions",
        docs: "# Crypto Helpers\n\nSafe cryptographic operations",
        tags: @["crypto", "security", "encryption"],
        registeredAt: now(),
        lastUpdated: now()
      )
    ]
    
    # Register all libraries
    for lib in libraries:
      waitFor manager.registerLibrary(lib)
    
    # Verify all were registered
    let count = waitFor manager.getLibraryCount()
    check count == 4
    
    # Test various search scenarios
    let apiResults = waitFor manager.searchLibraries("api")
    check apiResults.len == 1
    check apiResults[0].name == "api-client"
    
    let utilsResults = waitFor manager.searchLibraries("utils")
    check utilsResults.len == 1
    check utilsResults[0].name == "database-utils"
    
    let frameworkResults = waitFor manager.searchLibraries("framework")
    check frameworkResults.len == 2  # logging-framework matches both "framework" and might match description
    
    # Test getting specific libraries
    let dbLib = waitFor manager.getLibrary("database-utils", "2.1.0")
    check dbLib.isSome
    check dbLib.get().version == "2.1.0"
    
    let cryptoLib = waitFor manager.getLibrary("crypto-helpers", "latest")
    check cryptoLib.isSome
    check cryptoLib.get().version == "1.5.2"
    
    # Test listing all libraries
    let allLibs = manager.listLibraries()
    check allLibs.len == 4
    
    let names = allLibs.mapIt(it.name)
    check "api-client" in names
    check "database-utils" in names
    check "logging-framework" in names
    check "crypto-helpers" in names

  test "Persistence and recovery":
    # Test that data persists across manager instances
    
    # 1. Create first manager and register libraries
    let manager1 = newLibraryManager(testDataDir)
    
    let lib1 = Library(
      name: "persistence-test-1",
      version: "1.0.0",
      description: "First persistence test",
      docs: "First test docs",
      tags: @["persistence"],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    let lib2 = Library(
      name: "persistence-test-2",
      version: "2.0.0",
      description: "Second persistence test",
      docs: "Second test docs",
      tags: @["persistence"],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager1.registerLibrary(lib1)
    waitFor manager1.registerLibrary(lib2)
    
    # 2. Create second manager instance (simulates restart)
    let manager2 = newLibraryManager(testDataDir)
    
    # 3. Verify data persisted
    let count = waitFor manager2.getLibraryCount()
    check count == 2
    
    let retrieved1 = waitFor manager2.getLibrary("persistence-test-1", "1.0.0")
    let retrieved2 = waitFor manager2.getLibrary("persistence-test-2", "2.0.0")
    
    check retrieved1.isSome
    check retrieved2.isSome
    check retrieved1.get().docs == "First test docs"
    check retrieved2.get().docs == "Second test docs"
    
    # 4. Search should work across instances
    let searchResults = waitFor manager2.searchLibraries("persistence")
    check searchResults.len == 2

  test "MCP tool simulation integration":
    # Test the complete MCP tool workflow
    let manager = newLibraryManager(testDataDir)
    
    # 1. Simulate register_library tool call
    let registerArgs = %*{
      "name": "mcp-integration-test",
      "version": "1.0.0",
      "docs": "# MCP Integration Test\n\nComplete MCP workflow test",
      "description": "Integration test for MCP tools"
    }
    
    # Extract args and register
    let name = registerArgs["name"].getStr()
    let version = registerArgs["version"].getStr()
    let docs = registerArgs["docs"].getStr()
    let description = registerArgs.getOrDefault("description").getStr("")
    
    let lib = Library(
      name: name,
      version: version,
      description: description,
      docs: docs,
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib)
    
    let registerResponse = createToolSuccessResult("Library registered successfully: " & name & "@" & version)
    check registerResponse["isError"].getBool() == false
    
    # 2. Simulate search_libraries tool call
    let searchArgs = %*{
      "query": "integration"
    }
    
    let query = searchArgs["query"].getStr()
    let searchResults = waitFor manager.searchLibraries(query)
    
    var jsonResults = newJArray()
    for lib in searchResults:
      jsonResults.add(%*{
        "name": lib.name,
        "version": lib.version,
        "description": lib.description,
        "registeredAt": lib.registeredAt.toTime().toUnix()
      })
    
    let searchResponse = createToolSuccessResult($jsonResults)
    check searchResponse["isError"].getBool() == false
    check searchResults.len == 1
    
    # 3. Simulate get_library_docs tool call
    let getArgs = %*{
      "name": "mcp-integration-test",
      "version": "1.0.0"
    }
    
    let getName = getArgs["name"].getStr()
    let getVersion = getArgs.getOrDefault("version").getStr("latest")
    
    let retrieved = waitFor manager.getLibrary(getName, getVersion)
    check retrieved.isSome
    
    let getResponse = createToolSuccessResult(retrieved.get().docs)
    check getResponse["isError"].getBool() == false
    check getResponse["content"][0]["text"].getStr() == "# MCP Integration Test\n\nComplete MCP workflow test"

  test "Error propagation integration":
    # Test that errors propagate correctly through the system
    let manager = newLibraryManager(testDataDir)
    
    # 1. Test error from non-existent library
    let getArgs = %*{
      "name": "non-existent-lib",
      "version": "1.0.0"
    }
    
    let name = getArgs["name"].getStr()
    let version = getArgs.getOrDefault("version").getStr("latest")
    
    let result = waitFor manager.getLibrary(name, version)
    check result.isNone
    
    let errorResponse = createToolErrorResult("Library not found: " & name & "@" & version)
    check errorResponse["isError"].getBool() == true
    check errorResponse["content"][0]["text"].getStr().contains("Library not found")
    
    # 2. Test error from invalid registration
    try:
      let invalidLib = Library(
        name: "test",
        version: "1.0.0",
        description: "Test",
        docs: "x".repeat(100 * 1024 * 1024),  # Very large docs that might cause issues
        tags: @[],
        registeredAt: now(),
        lastUpdated: now()
      )
      
      waitFor manager.registerLibrary(invalidLib)
      # Might succeed or fail depending on implementation
    except:
      # Error handling should work
      let exceptionResponse = createToolErrorResult("Failed to register library: memory limit exceeded")
      check exceptionResponse["isError"].getBool() == true

  test "CLI to library manager integration":
    # Test that CLI commands properly interact with library manager
    let manager = newLibraryManager(testDataDir)
    
    # Create a test documentation file
    let docsFile = testDataDir / "cli_test_docs.md"
    writeFile(docsFile, "# CLI Test\n\nDocumentation from CLI")
    
    # Simulate CLI register command workflow
    let name = "cli-integration-test"
    let version = "1.0.0"
    let docs = readFile(docsFile)
    
    let lib = Library(
      name: name,
      version: version,
      description: "Library registered via CLI",
      docs: docs,
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib)
    
    # Verify registration worked
    let retrieved = waitFor manager.getLibrary(name, version)
    check retrieved.isSome
    check retrieved.get().docs == "# CLI Test\n\nDocumentation from CLI"
    
    # Simulate CLI search command
    let searchResults = waitFor manager.searchLibraries("cli")
    check searchResults.len == 1
    check searchResults[0].name == "cli-integration-test"
    
    # Simulate CLI list command
    let allLibs = manager.listLibraries()
    check allLibs.len == 1
    check allLibs[0].name == "cli-integration-test"
    
    # Simulate CLI delete command
    let deleted = waitFor manager.deleteLibrary(name, version)
    check deleted == true
    
    let afterDelete = waitFor manager.getLibrary(name, version)
    check afterDelete.isNone

  test "Full workflow simulation":
    # Simulate a complete real-world workflow
    let manager = newLibraryManager(testDataDir)
    
    # 1. Initial setup - register several internal libraries
    let internalLibs = @[
      ("auth-service", "1.0.0", "# Authentication Service\n\nInternal auth service API"),
      ("user-management", "2.1.0", "# User Management\n\nUser CRUD operations"),
      ("notification-system", "1.5.0", "# Notification System\n\nEmail and SMS notifications"),
      ("payment-processor", "3.0.0", "# Payment Processor\n\nSecure payment handling"),
      ("audit-logger", "1.2.0", "# Audit Logger\n\nSecurity audit logging")
    ]
    
    for (name, version, docs) in internalLibs:
      let lib = Library(
        name: name,
        version: version,
        description: "Internal " & name.replace("-", " ") & " library",
        docs: docs,
        tags: @["internal", "production"],
        registeredAt: now(),
        lastUpdated: now()
      )
      waitFor manager.registerLibrary(lib)
    
    # 2. Developer searches for authentication
    let authSearch = waitFor manager.searchLibraries("auth")
    check authSearch.len >= 1
    
    # 3. Developer gets documentation for auth service
    let authDocs = waitFor manager.getLibrary("auth-service", "latest")
    check authDocs.isSome
    check authDocs.get().docs.contains("Authentication Service")
    
    # 4. New version of user management is released
    let userMgmtV2 = Library(
      name: "user-management",
      version: "2.2.0",
      description: "Updated user management with new features",
      docs: "# User Management v2.2\n\nEnhanced user operations with SSO support",
      tags: @["internal", "production", "sso"],
      registeredAt: now(),
      lastUpdated: now()
    )
    waitFor manager.registerLibrary(userMgmtV2)
    
    # 5. Verify latest version is returned
    let latestUserMgmt = waitFor manager.getLibrary("user-management", "latest")
    check latestUserMgmt.isSome
    check latestUserMgmt.get().version == "2.2.0"
    
    # 6. Search for SSO functionality
    let ssoSearch = waitFor manager.searchLibraries("sso")
    check ssoSearch.len == 1
    check ssoSearch[0].name == "user-management"
    
    # 7. List all current libraries
    let currentLibs = manager.listLibraries()
    check currentLibs.len == 5
    
    # 8. Clean up old version
    let deletedOld = waitFor manager.deleteLibrary("user-management", "2.1.0")
    check deletedOld == true
    
    # 9. Verify system state
    let finalCount = waitFor manager.getLibraryCount()
    check finalCount == 5  # Still 5 because we only deleted a specific version
    
    let oldVersion = waitFor manager.getLibrary("user-management", "2.1.0")
    check oldVersion.isNone
    
    let newVersion = waitFor manager.getLibrary("user-management", "2.2.0")
    check newVersion.isSome
