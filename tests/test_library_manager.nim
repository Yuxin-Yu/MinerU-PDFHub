##[
  Tests for Library Manager
]##

import unittest, asyncdispatch, times, os, json, options
import ../src/library_manager

suite "Library Manager Tests":
  let testDataDir = "/tmp/mineru_pdfhub_test"
  
  setup:
    removeDir(testDataDir)
    createDir(testDataDir)
  
  teardown:
    removeDir(testDataDir)
  
  test "Create library manager":
    let manager = newLibraryManager(testDataDir)
    check manager != nil
    check dirExists(testDataDir)
  
  test "Register and retrieve library":
    let manager = newLibraryManager(testDataDir)
    
    let library = Library(
      name: "test-lib",
      version: "1.0.0",
      description: "Test library",
      docs: "# Test Library\n\nThis is a test library.",
      tags: @["test"],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(library)
    
    let retrieved = waitFor manager.getLibrary("test-lib", "1.0.0")
    check retrieved.isSome()
    check retrieved.get().name == "test-lib"
    check retrieved.get().version == "1.0.0"
    check retrieved.get().docs == "# Test Library\n\nThis is a test library."
  
  test "Search libraries":
    let manager = newLibraryManager(testDataDir)
    
    let lib1 = Library(
      name: "json-parser",
      version: "1.0.0", 
      description: "A JSON parsing library",
      docs: "JSON parser docs",
      tags: @["json", "parser"],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    let lib2 = Library(
      name: "http-client",
      version: "2.0.0",
      description: "HTTP client library", 
      docs: "HTTP client docs",
      tags: @["http", "network"],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib1)
    waitFor manager.registerLibrary(lib2)
    
    let jsonResults = waitFor manager.searchLibraries("json")
    check jsonResults.len == 1
    check jsonResults[0].name == "json-parser"
    
    let httpResults = waitFor manager.searchLibraries("http")
    check httpResults.len == 1
    check httpResults[0].name == "http-client"
    
    let parserResults = waitFor manager.searchLibraries("parser")
    check parserResults.len == 1
    check parserResults[0].name == "json-parser"
  
  test "Get latest version":
    let manager = newLibraryManager(testDataDir)
    
    let lib1 = Library(
      name: "my-lib",
      version: "1.0.0",
      description: "Version 1",
      docs: "Version 1 docs",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    let lib2 = Library(
      name: "my-lib", 
      version: "2.0.0",
      description: "Version 2",
      docs: "Version 2 docs",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib1)
    waitFor manager.registerLibrary(lib2)
    
    let latest = waitFor manager.getLibrary("my-lib", "latest")
    check isSome(latest)
    check latest.get().version == "2.0.0"
    check latest.get().docs == "Version 2 docs"
  
  test "Delete library":
    let manager = newLibraryManager(testDataDir)
    
    let library = Library(
      name: "delete-me",
      version: "1.0.0",
      description: "To be deleted",
      docs: "Delete me docs",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(library)
    
    let before = waitFor manager.getLibrary("delete-me", "1.0.0")
    check isSome(before)
    
    let deleted = waitFor manager.deleteLibrary("delete-me", "1.0.0")
    check deleted == true
    
    let after = waitFor manager.getLibrary("delete-me", "1.0.0")
    check after.isNone