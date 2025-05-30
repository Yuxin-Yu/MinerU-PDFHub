#!/bin/bash
# Build script for compiling Nim shared logic to WebAssembly

set -e

echo "Building Context7 WASM module..."

# Install Emscripten if not available
if ! command -v emcc &> /dev/null; then
    echo "Emscripten not found. Please install it first."
    echo "Visit: https://emscripten.org/docs/getting_started/downloads.html"
    exit 1
fi

# Create output directory
mkdir -p frontend/public

# Compile Nim to C
echo "Compiling Nim to C..."
nim c --cpu:wasm32 --os:standalone --gc:orc -d:release --nimcache:nimcache/wasm -c shared/src/shared_logic.nim

# Compile C to WASM using Emscripten
echo "Compiling C to WASM..."
emcc nimcache/wasm/*.c \
    -O3 \
    -s WASM=1 \
    -s EXPORTED_FUNCTIONS='["_wasmCalculateSearchScore","_wasmCompareVersions","_wasmIsValidLibraryName","_wasmIsValidVersion","_wasmIsValidOrgName"]' \
    -s EXPORTED_RUNTIME_METHODS='["ccall","cwrap"]' \
    -s ALLOW_MEMORY_GROWTH=1 \
    -o frontend/public/context7.js

echo "WASM build complete!"
echo "Output files:"
echo "  - frontend/public/context7.js"
echo "  - frontend/public/context7.wasm"