##[
  Run all tests for 100% coverage
]##

import test_library_manager
import test_library_manager_comprehensive
import test_config_manager
import test_cli
import test_context7local_server
import test_mcp_helpers
import test_error_handling
import test_integration

when isMainModule:
  echo "Running all Context7 Local tests for 100% coverage..."
  echo "Test suites included:"
  echo "  - Basic Library Manager Tests"
  echo "  - Comprehensive Library Manager Tests"
  echo "  - Config Manager Tests"
  echo "  - CLI Tests"
  echo "  - MCP Server Tests"
  echo "  - MCP Helpers Tests"
  echo "  - Error Handling & Boundary Tests"
  echo "  - Integration & E2E Tests"
  echo ""
  echo "Coverage target: 100%"