# Package
version       = "0.1.0"
author        = "Context7 Team"
description   = "Context7 SaaS - Cloud-based library documentation service"
license       = "MIT"
srcDir        = "backend/src"
bin           = @["context7_saas"]

# Dependencies
requires "nim >= 2.0.0"
requires "jester"
requires "jsony"
requires "yaml"
requires "jwt"
requires "bcrypt"
requires "chronicles"
requires "db_postgres"
requires "redis"
requires "uuids"
requires "chronos"

# Tasks
task dev, "Run development server":
  exec "nim c -r -d:debug backend/src/context7_saas.nim"

task build, "Build production server":
  exec "nim c -d:release -d:ssl --opt:speed backend/src/context7_saas.nim"

task build_wasm, "Build shared logic to WASM":
  exec "nim c --cpu:wasm32 --os:standalone --gc:orc -d:release -o:frontend/public/context7.wasm shared/src/shared_logic.nim"

task test, "Run all tests":
  exec "nim c -r backend/tests/test_all.nim"
  exec "nim c -r shared/tests/test_shared.nim"

task clean, "Clean build artifacts":
  exec "rm -rf nimcache/"
  exec "rm -f context7_saas"
  exec "rm -f frontend/public/context7.wasm"