##[
  Simple usage example for MinerU-PDFHub
]##

import std/[asyncdispatch, json]
import ../src/[library_manager, config_manager]

proc main() {.async.} =
  echo "MinerU-PDFHub - Simple Usage Example"
  echo "======================================"
  
  # Initialize manager
  let config = getDefaultConfig()
  let manager = newLibraryManager(config.storage.dataDir)
  
  # Register a sample library
  let sampleLibrary = Library(
    name: "my-internal-lib",
    version: "1.2.3",
    description: "Internal utility library for our company",
    docs: """
# My Internal Library v1.2.3

## Overview
This is our internal utility library that provides common functions
for data processing and API interactions.

## Installation
```bash
npm install @company/my-internal-lib
```

## Usage
```javascript
import { processData, apiCall } from '@company/my-internal-lib';

const result = processData(inputData);
const response = await apiCall('/api/endpoint', data);
```

## API Reference

### processData(data)
Processes raw data and returns formatted output.
- **data**: Raw input data (Object)
- **Returns**: Processed data (Object)

### apiCall(endpoint, data)
Makes authenticated API calls to internal services.
- **endpoint**: API endpoint path (String)
- **data**: Request payload (Object)
- **Returns**: Promise<Response>
""",
    tags: @["internal", "utility", "api"],
    registeredAt: now(),
    lastUpdated: now()
  )
  
  echo "Registering library..."
  await manager.registerLibrary(sampleLibrary)
  echo "✓ Library registered: ", sampleLibrary.name, "@", sampleLibrary.version
  
  # Search for libraries
  echo "\nSearching for 'internal' libraries..."
  let searchResults = await manager.searchLibraries("internal")
  for lib in searchResults:
    echo "  Found: ", lib.name, "@", lib.version, " - ", lib.description
  
  # Get library documentation
  echo "\nRetrieving library documentation..."
  let retrieved = await manager.getLibrary("my-internal-lib", "latest")
  if retrieved.isSome:
    let lib = retrieved.get()
    echo "✓ Retrieved: ", lib.name, "@", lib.version
    echo "Documentation length: ", lib.docs.len, " characters"
  else:
    echo "✗ Library not found"
  
  # List all libraries
  echo "\nAll registered libraries:"
  let allLibs = manager.listLibraries()
  for lib in allLibs:
    echo "  ", lib.name, "@", lib.version

when isMainModule:
  waitFor main()