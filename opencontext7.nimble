# Package

version       = "0.0.0"
author        = "jasagiri"
description   = "On-premises MCP server for private library documentation"
license       = "MIT"
srcDir        = "src"
bin           = @["opencontext7"]

# Dependencies

requires "nim >= 2.0.0"
requires "jsony >= 1.1.3"
requires "httpbeast >= 0.4.1"
requires "ws >= 0.5.0"
requires "uri3 >= 0.2.1"
requires "uuids >= 0.1.11"
requires "yaml >= 2.1.1"
requires "taskpools >= 0.1.0"

task docs, "Generate documentation":
  exec "nim doc --project --index:on --outdir:docs/generated src/opencontext7.nim"

task test, "Run tests":
  putEnv("OPENCONTEXT7_SKIP_SERVER", "1")
  exec "nim c -r tests/test_all.nim"

task test_coverage, "Run tests with coverage":
  putEnv("OPENCONTEXT7_SKIP_SERVER", "1")
  exec "nim c --lineTrace:on --stackTrace:on -r tests/test_all.nim"

task test_verbose, "Run tests with verbose output":
  putEnv("OPENCONTEXT7_SKIP_SERVER", "1")
  exec "nim c -r tests/test_all.nim --verbose"

task test_comprehensive, "Run comprehensive test suite":
  echo "Running comprehensive test suite..."
  putEnv("OPENCONTEXT7_SKIP_SERVER", "1")
  exec "nim c -r tests/test_library_manager_comprehensive.nim"
  exec "nim c -r tests/test_config_manager.nim"
  exec "nim c -r tests/test_cli.nim"
  exec "nim c -r tests/test_opencontext7_server.nim"
  exec "nim c -r tests/test_mcp_helpers.nim"
  exec "nim c -r tests/test_error_handling.nim"
  exec "nim c -r tests/test_integration.nim"
  echo "All test suites completed!"

task test_coverage_report, "Generate test coverage report":
  echo "Generating test coverage report..."
  exec "nim c --lineTrace:on --stackTrace:on --debugInfo:on -r tests/test_all.nim"
  echo "Coverage report generated."
  echo "For detailed coverage analysis, use: nim c --lineTrace:on --debugger:native"

task build, "Build the project":
  exec "nim c src/opencontext7.nim"

task clean, "Clean build artifacts":
  exec "rm -f src/opencontext7"
  exec "rm -rf nimcache/"
  exec "rm -rf .nimcache/"

task dev, "Run in development mode":
  exec "nim c -r src/opencontext7.nim"
