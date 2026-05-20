##[
  Comprehensive tests for Library Manager - 100% coverage
]##

import unittest, asyncdispatch, times, os, json, strutils, tables, options, sequtils
import ../src/library_manager

suite "Library Manager Comprehensive Tests":
  let testDataDir = "/tmp/mineru_pdfhub_test_comprehensive"
  
  setup:
    removeDir(testDataDir)
    createDir(testDataDir)
  
  teardown:
    removeDir(testDataDir)

  test "Library hash function":
    let lib1 = Library(
      name: "test",
      version: "1.0.0",
      description: "",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    let lib2 = Library(
      name: "test",
      version: "1.0.0",
      description: "different",
      docs: "different",
      tags: @["different"],
      registeredAt: now(),
      lastUpdated: now()
    )
    let lib3 = Library(
      name: "test",
      version: "2.0.0",
      description: "",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    check hash(lib1) == hash(lib2)  # Same name and version
    check hash(lib1) != hash(lib3)  # Different version

  test "Create library manager with custom data dir":
    let customDir = testDataDir / "custom"
    let manager = newLibraryManager(customDir)
    check manager != nil
    check manager.dataDir == customDir
    check dirExists(customDir)

  test "Get library file path":
    let manager = newLibraryManager(testDataDir)
    let path = manager.getLibraryFile("test-lib", "1.0.0")
    check path.contains("test-lib_1.0.0.json")

  test "Get library file path with special characters":
    let manager = newLibraryManager(testDataDir)
    let path = manager.getLibraryFile("@company/lib", "1.0.0-beta")
    check not path.contains("@")
    # Only check the filename part, not the full path
    let filename = path.splitPath().tail
    check not filename.contains("/")
    check filename == "_company_lib_1.0.0-beta.json"

  test "Get index file path":
    let manager = newLibraryManager(testDataDir)
    let path = manager.getIndexFile()
    check path == testDataDir / "index.json"

  test "Save and load library to/from disk":
    let manager = newLibraryManager(testDataDir)
    let library = Library(
      name: "disk-test",
      version: "1.0.0",
      description: "Test library for disk operations",
      docs: "# Disk Test\n\nTest content",
      tags: @["test", "disk"],
      registeredAt: parse("2024-01-01T00:00:00", "yyyy-MM-dd'T'HH:mm:ss", utc()),
      lastUpdated: parse("2024-01-02T00:00:00", "yyyy-MM-dd'T'HH:mm:ss", utc())
    )
    
    waitFor manager.saveLibraryToDisk(library)
    
    let loaded = waitFor manager.loadLibraryFromDisk("disk-test", "1.0.0")
    check loaded.isSome
    let lib = loaded.get()
    check lib.name == "disk-test"
    check lib.version == "1.0.0"
    check lib.description == "Test library for disk operations"
    check lib.docs == "# Disk Test\n\nTest content"
    check lib.tags == @["test", "disk"]

  test "Load non-existent library from disk":
    let manager = newLibraryManager(testDataDir)
    let loaded = waitFor manager.loadLibraryFromDisk("non-existent", "1.0.0")
    check loaded.isNone

  test "Load corrupted library file":
    let manager = newLibraryManager(testDataDir)
    let filePath = manager.getLibraryFile("corrupted", "1.0.0")
    writeFile(filePath, "invalid json content")
    
    let loaded = waitFor manager.loadLibraryFromDisk("corrupted", "1.0.0")
    check loaded.isNone

  test "Save and load index":
    let manager = newLibraryManager(testDataDir)
    
    # Add some libraries to the index
    manager.index.libraries["lib1"] = @[
      Library(
        name: "lib1",
        version: "1.0.0",
        description: "Library 1",
        docs: "",
        tags: @["tag1"],
        registeredAt: now(),
        lastUpdated: now()
      )
    ]
    manager.index.searchIndex["keyword"] = @["lib1"]
    
    waitFor manager.saveIndex()
    
    # Create new manager and load index
    let newManager = newLibraryManager(testDataDir)
    waitFor newManager.loadIndex()
    
    check "lib1" in newManager.index.libraries
    check newManager.index.libraries["lib1"].len == 1
    check newManager.index.libraries["lib1"][0].name == "lib1"
    check "keyword" in newManager.index.searchIndex
    check newManager.index.searchIndex["keyword"] == @["lib1"]

  test "Load index from non-existent file":
    let manager = newLibraryManager(testDataDir)
    waitFor manager.loadIndex()
    check manager.index.libraries.len == 0

  test "Load corrupted index file":
    let manager = newLibraryManager(testDataDir)
    writeFile(manager.getIndexFile(), "invalid json")
    waitFor manager.loadIndex()
    check manager.index.libraries.len == 0

  test "Update search index":
    let manager = newLibraryManager(testDataDir)
    let library = Library(
      name: "search-test-lib",
      version: "1.0.0",
      description: "A test library for searching functionality",
      docs: "",
      tags: @["search", "test", "utility"],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    manager.updateSearchIndex(library)
    
    check "search-test-lib" in manager.index.searchIndex["search"]
    check "search-test-lib" in manager.index.searchIndex["test"]
    check "search-test-lib" in manager.index.searchIndex["utility"]
    check "search-test-lib" in manager.index.searchIndex["library"]
    check "search-test-lib" in manager.index.searchIndex["searching"]
    check "search-test-lib" in manager.index.searchIndex["functionality"]

  test "Update search index with short words":
    let manager = newLibraryManager(testDataDir)
    let library = Library(
      name: "a-b",
      version: "1.0.0",
      description: "A library with short words: a, is, of",
      docs: "",
      tags: @["a", "is"],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    manager.updateSearchIndex(library)
    
    # Short words (length <= 2) should be skipped
    check "a" notin manager.index.searchIndex
    check "is" notin manager.index.searchIndex
    check "of" notin manager.index.searchIndex

  test "Register library with version replacement":
    let manager = newLibraryManager(testDataDir)
    
    let lib1 = Library(
      name: "version-test",
      version: "1.0.0",
      description: "Version 1",
      docs: "Version 1 docs",
      tags: @[],
      registeredAt: parse("2024-01-01T00:00:00", "yyyy-MM-dd'T'HH:mm:ss", utc()),
      lastUpdated: parse("2024-01-01T00:00:00", "yyyy-MM-dd'T'HH:mm:ss", utc())
    )
    
    let lib2 = Library(
      name: "version-test",
      version: "1.0.0",
      description: "Version 1 Updated",
      docs: "Version 1 updated docs",
      tags: @["updated"],
      registeredAt: parse("2024-01-01T00:00:00", "yyyy-MM-dd'T'HH:mm:ss", utc()),
      lastUpdated: parse("2024-01-02T00:00:00", "yyyy-MM-dd'T'HH:mm:ss", utc())
    )
    
    waitFor manager.registerLibrary(lib1)
    waitFor manager.registerLibrary(lib2)  # Should replace lib1
    
    check manager.index.libraries["version-test"].len == 1
    check manager.index.libraries["version-test"][0].description == "Version 1 Updated"

  test "Register multiple versions with sorting":
    let sortTestDir = testDataDir & "_sort"
    removeDir(sortTestDir)
    createDir(sortTestDir) 
    let manager = newLibraryManager(sortTestDir)
    
    # Register in order with small delays to ensure different timestamps
    let lib1 = Library(
      name: "multi-version",
      version: "1.0.0",
      description: "Version 1",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()  # This will be overwritten by registerLibrary
    )
    waitFor manager.registerLibrary(lib1)
    sleep(10)  # Small delay to ensure different timestamp
    
    let lib2 = Library(
      name: "multi-version",
      version: "1.5.0",
      description: "Version 1.5",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    waitFor manager.registerLibrary(lib2)
    sleep(10)
    
    let lib3 = Library(
      name: "multi-version",
      version: "2.0.0",
      description: "Version 2",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    waitFor manager.registerLibrary(lib3)
    
    let versions = manager.index.libraries["multi-version"]
    check versions.len == 3
    # Should be sorted by lastUpdated (latest first)
    # Since we registered them in order 1.0.0, 1.5.0, 2.0.0 with delays
    # The order should be reversed: 2.0.0 (latest), 1.5.0, 1.0.0
    check versions[0].version == "2.0.0"
    check versions[1].version == "1.5.0"
    check versions[2].version == "1.0.0"
    
    # Cleanup
    removeDir(sortTestDir)

  test "Get library with specific version":
    let manager = newLibraryManager(testDataDir)
    
    let lib = Library(
      name: "specific-version",
      version: "1.2.3",
      description: "Specific version test",
      docs: "Specific version docs",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib)
    
    let retrieved = waitFor manager.getLibrary("specific-version", "1.2.3")
    check retrieved.isSome
    check retrieved.get().version == "1.2.3"

  test "Get library with latest version":
    let manager = newLibraryManager(testDataDir)
    
    let lib1 = Library(
      name: "latest-test",
      version: "1.0.0",
      description: "Version 1",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: parse("2024-01-01T00:00:00", "yyyy-MM-dd'T'HH:mm:ss", utc())
    )
    
    let lib2 = Library(
      name: "latest-test",
      version: "2.0.0",
      description: "Version 2",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: parse("2024-01-02T00:00:00", "yyyy-MM-dd'T'HH:mm:ss", utc())
    )
    
    waitFor manager.registerLibrary(lib1)
    waitFor manager.registerLibrary(lib2)
    
    let latest = waitFor manager.getLibrary("latest-test", "latest")
    check latest.isSome
    check latest.get().version == "2.0.0"

  test "Get non-existent library":
    let manager = newLibraryManager(testDataDir)
    
    let result = waitFor manager.getLibrary("non-existent", "1.0.0")
    check result.isNone

  test "Get non-existent version":
    let manager = newLibraryManager(testDataDir)
    
    let lib = Library(
      name: "version-test",
      version: "1.0.0",
      description: "Version 1",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib)
    
    let result = waitFor manager.getLibrary("version-test", "2.0.0")
    check result.isNone

  test "Search libraries by name":
    let manager = newLibraryManager(testDataDir)
    
    let lib1 = Library(
      name: "json-parser",
      version: "1.0.0",
      description: "Parse JSON data",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    let lib2 = Library(
      name: "xml-parser",
      version: "1.0.0",
      description: "Parse XML data",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib1)
    waitFor manager.registerLibrary(lib2)
    
    let jsonResults = waitFor manager.searchLibraries("json")
    check jsonResults.len == 1
    check jsonResults[0].name == "json-parser"

  test "Search libraries by partial name match":
    let manager = newLibraryManager(testDataDir)
    
    let lib = Library(
      name: "my-awesome-library",
      version: "1.0.0",
      description: "An awesome library",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib)
    
    let results = waitFor manager.searchLibraries("awesome")
    check results.len == 1
    check results[0].name == "my-awesome-library"

  test "Search libraries by multiple keywords":
    let manager = newLibraryManager(testDataDir)
    
    let lib = Library(
      name: "data-processing-lib",
      version: "1.0.0",
      description: "Library for data processing and analysis",
      docs: "",
      tags: @["data", "processing"],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib)
    
    let results = waitFor manager.searchLibraries("data processing")
    check results.len == 1
    check results[0].name == "data-processing-lib"

  test "Search with no results":
    let manager = newLibraryManager(testDataDir)
    
    let results = waitFor manager.searchLibraries("nonexistent")
    check results.len == 0

  test "List libraries":
    let manager = newLibraryManager(testDataDir)
    
    let lib1 = Library(
      name: "lib1",
      version: "1.0.0",
      description: "Library 1",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    let lib2 = Library(
      name: "lib2",
      version: "1.0.0",
      description: "Library 2",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib1)
    waitFor manager.registerLibrary(lib2)
    
    let libraries = manager.listLibraries()
    check libraries.len == 2
    let names = libraries.mapIt(it.name)
    check "lib1" in names
    check "lib2" in names

  test "List libraries with multiple versions":
    let manager = newLibraryManager(testDataDir)
    
    let lib1 = Library(
      name: "multi-lib",
      version: "1.0.0",
      description: "Version 1",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: parse("2024-01-01T00:00:00", "yyyy-MM-dd'T'HH:mm:ss", utc())
    )
    
    let lib2 = Library(
      name: "multi-lib",
      version: "2.0.0",
      description: "Version 2",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: parse("2024-01-02T00:00:00", "yyyy-MM-dd'T'HH:mm:ss", utc())
    )
    
    waitFor manager.registerLibrary(lib1)
    waitFor manager.registerLibrary(lib2)
    
    let libraries = manager.listLibraries()
    check libraries.len == 1  # Only latest version
    check libraries[0].version == "2.0.0"

  test "Get library count":
    let manager = newLibraryManager(testDataDir)
    
    let initialCount = waitFor manager.getLibraryCount()
    check initialCount == 0
    
    let lib = Library(
      name: "count-test",
      version: "1.0.0",
      description: "Test",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib)
    
    let finalCount = waitFor manager.getLibraryCount()
    check finalCount == 1

  test "Delete specific library version":
    let manager = newLibraryManager(testDataDir)
    
    let lib1 = Library(
      name: "delete-test",
      version: "1.0.0",
      description: "Version 1",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    let lib2 = Library(
      name: "delete-test",
      version: "2.0.0",
      description: "Version 2",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib1)
    waitFor manager.registerLibrary(lib2)
    
    let deleted = waitFor manager.deleteLibrary("delete-test", "1.0.0")
    check deleted == true
    
    let remaining = manager.index.libraries["delete-test"]
    check remaining.len == 1
    check remaining[0].version == "2.0.0"

  test "Delete all library versions":
    let manager = newLibraryManager(testDataDir)
    
    let lib1 = Library(
      name: "delete-all-test",
      version: "1.0.0",
      description: "Version 1",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    let lib2 = Library(
      name: "delete-all-test",
      version: "2.0.0",
      description: "Version 2",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib1)
    waitFor manager.registerLibrary(lib2)
    
    let deleted = waitFor manager.deleteLibrary("delete-all-test", "")
    check deleted == true
    
    check "delete-all-test" notin manager.index.libraries

  test "Delete non-existent library":
    let manager = newLibraryManager(testDataDir)
    
    let deleted = waitFor manager.deleteLibrary("non-existent", "1.0.0")
    check deleted == false

  test "Delete last version removes library from index":
    let manager = newLibraryManager(testDataDir)
    
    let lib = Library(
      name: "last-version-test",
      version: "1.0.0",
      description: "Only version",
      docs: "",
      tags: @[],
      registeredAt: now(),
      lastUpdated: now()
    )
    
    waitFor manager.registerLibrary(lib)
    
    let deleted = waitFor manager.deleteLibrary("last-version-test", "1.0.0")
    check deleted == true
    
    check "last-version-test" notin manager.index.libraries