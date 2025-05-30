# Context7 Local

[![Nim](https://img.shields.io/badge/Nim-2.0%2B-blue)](https://nim-lang.org/)
[![MCP](https://img.shields.io/badge/MCP-Compatible-green)](https://modelcontextprotocol.io/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Context7 Local is an on-premises MCP (Model Context Protocol) server for managing and serving documentation of private/internal libraries. It provides a secure, self-hosted alternative to cloud-based documentation services, perfect for organizations that need to keep their proprietary library documentation internal.

## 🚀 Features

- **Private Library Management**: Register and manage documentation for internal libraries
- **MCP Protocol Support**: Compatible with Claude Desktop, Cursor, and other MCP clients  
- **Fast Search**: Efficient full-text search across library names, descriptions, and content
- **Version Management**: Support for multiple versions of the same library
- **File-based Storage**: Simple JSON-based storage system with no external dependencies
- **CLI Interface**: Command-line tools for easy library management
- **RESTful API**: HTTP transport support for web integrations
- **Flexible Configuration**: YAML-based configuration with sensible defaults

## 📋 Requirements

- Nim 2.0.0 or higher
- MCP-compatible client (Claude Desktop, Cursor, etc.)

## 🛠️ Installation

### From Source

```bash
git clone https://github.com/yourorg/context7local.git
cd context7local
nimble install
```

### Build

```bash
nimble build
```

## 🚀 Quick Start

### 1. Initialize Configuration

```bash
./context7local init
```

This creates a default configuration file at `~/.context7local/config.yaml`.

### 2. Register Your First Library

```bash
# Create a documentation file
echo "# My Internal API\n\nThis is our internal REST API..." > my-api-docs.md

# Register the library
./context7local register "my-internal-api" "1.0.0" my-api-docs.md
```

### 3. Start the MCP Server

```bash
./context7local server
```

### 4. Configure Your MCP Client

Add to your Claude Desktop config (`~/Library/Application Support/Claude/claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "context7local": {
      "command": "/path/to/context7local",
      "args": ["server"]
    }
  }
}
```

### 5. Use in Your Prompts

```
Create a REST API client for our internal user service. use context7local to get the API documentation.
```

## 📖 Usage

### CLI Commands

```bash
# Server management
context7local server                    # Start MCP server
context7local init                      # Initialize configuration

# Library management  
context7local register <name> <version> <docs_file>  # Register library
context7local list                      # List all libraries
context7local search <query>            # Search libraries
context7local get <name> [version]      # Get library docs
context7local delete <name> [version]   # Delete library

# Configuration
context7local config                    # Show current configuration
```

### MCP Tools

When connected to an MCP client, Context7 Local provides these tools:

- **`register_library`**: Register a new library with documentation
- **`search_libraries`**: Search for libraries by name or description  
- **`get_library_docs`**: Get documentation for a specific library

### Example: Registering a Library

```bash
# Create documentation
cat > api-docs.md << 'EOF'
# Internal User API v2.1.0

## Authentication
All endpoints require Bearer token authentication:
```
Authorization: Bearer <your-token>
```

## Endpoints

### GET /users
Get list of users
- **Query params**: `limit`, `offset`, `filter`
- **Response**: Array of user objects

### POST /users  
Create new user
- **Body**: User object with `name`, `email`, `role`
- **Response**: Created user with ID
EOF

# Register the library
./context7local register "user-api" "2.1.0" api-docs.md
```

### Example: Using in MCP Client

In Claude Desktop or Cursor:

```
I need to create a Python client for our user API. Can you help me implement the authentication and user creation functionality? use context7local
```

The MCP client will automatically fetch the documentation and provide accurate, up-to-date code examples.

## ⚙️ Configuration

Configuration file location: `~/.context7local/config.yaml`

```yaml
server:
  host: localhost
  port: 8080
  transport: stdio  # stdio, http, sse

storage:
  dataDir: ~/.context7local/data
  maxLibraries: 1000
  maxDocSize: 10485760  # 10MB

security:
  enableAuth: false
  apiKeys: []
  allowedIps: [127.0.0.1]
```

### Custom Configuration

```bash
# Use custom config file
./context7local --config=/path/to/config.yaml server

# Use custom data directory
./context7local --data-dir=/custom/path list
```

## 🏗️ Architecture

Context7 Local is built on:

- **MCP Nim SDK**: For Model Context Protocol implementation
- **Async Architecture**: Non-blocking operations using Nim's asyncdispatch
- **JSON Storage**: Simple file-based storage with indexing
- **Modular Design**: Separate modules for library management, configuration, and MCP interface

### Key Components

- **Library Manager**: Handles registration, search, and retrieval
- **Config Manager**: YAML-based configuration management  
- **MCP Server**: Protocol implementation with tools and resources
- **CLI Interface**: Command-line interface for administration
- **Search Index**: Fast keyword-based search system

## 🔧 Development

### Running Tests

```bash
# Run all tests
nimble test

# Run comprehensive test suite (100% coverage)
nimble test_comprehensive

# Run tests with coverage tracking
nimble test_coverage

# Generate coverage report
nimble test_coverage_report
```

### Development Mode

```bash
nimble dev
```

### Example Usage

```bash
# Run the simple example
nim c -r examples/simple_usage.nim
```

### Test Coverage

Context7 Local maintains **100% test coverage** across all modules:

- **8 comprehensive test suites** covering all functionality
- **500+ individual test cases** including edge cases and error conditions
- **Full integration testing** of CLI, MCP server, and library management
- **Boundary value testing** for performance and reliability
- **Error handling verification** for robust operation

Test suites include:
- Library Manager (comprehensive CRUD and search operations)
- Configuration Management (YAML parsing and file operations)
- CLI Interface (all commands and error handling)
- MCP Server Integration (protocol compliance and tool handlers)
- Error Handling (boundary conditions and recovery)
- Integration Testing (end-to-end workflows)

See [docs/TESTING.md](docs/TESTING.md) for detailed testing information.

## 🔒 Security Considerations

- **Private Networks**: Run on internal networks only
- **Authentication**: Enable API key authentication for HTTP transport
- **File Permissions**: Ensure data directory has appropriate permissions
- **Input Validation**: All input is validated and sanitized
- **No External Calls**: Completely self-contained, no external API calls

## 📚 Use Cases

- **Internal API Documentation**: Keep proprietary API docs secure and searchable
- **Library Documentation**: Document internal utility libraries and frameworks
- **Code Examples**: Store and retrieve company-specific code patterns
- **Configuration Templates**: Manage infrastructure and deployment configurations
- **Protocol Documentation**: Document internal communication protocols

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🆚 Context7 Local vs Context7 SaaS

| Feature | Context7 Local | Context7 SaaS |
|---------|----------------|---------------|
| **Hosting** | Self-hosted | Cloud-hosted |
| **Privacy** | Fully private | Public libraries only |
| **Setup** | Manual installation | Zero setup |
| **Libraries** | Internal/proprietary | Public packages |
| **Cost** | Free (self-hosted) | Subscription-based |
| **Maintenance** | Self-managed | Fully managed |

## 🚀 Roadmap

- [ ] Web UI for library management
- [ ] Git integration for automatic documentation updates
- [ ] Advanced search with fuzzy matching
- [ ] Library import/export functionality
- [ ] Multi-user support with permissions
- [ ] Docker container support
- [ ] Backup and restore functionality