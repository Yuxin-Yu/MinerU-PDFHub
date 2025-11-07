# OpenContext7

[![Nim](https://img.shields.io/badge/Nim-2.0%2B-blue)](https://nim-lang.org/)
[![MCP](https://img.shields.io/badge/MCP-Compatible-green)](https://modelcontextprotocol.io/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

OpenContext7 is an on-premises MCP (Model Context Protocol) server for managing and serving documentation of private/internal libraries. It provides a secure, self-hosted alternative to cloud-based documentation services, perfect for organizations that need to keep their proprietary library documentation internal.

👉 Looking for the Chinese guide? Check out the [中文文档](README_CN.md).

## 📑 Table of Contents

- [🧭 Project Overview](#-project-overview)
- [🚀 Features](#-features)
- [📋 Requirements](#-requirements)
- [🛠️ Installation](#%EF%B8%8F-installation)
- [🚀 Quick Start](#-quick-start)
- [📖 Usage](#-usage)
- [🔁 Feature Guides](#-feature-guides)
- [📦 Project Structure Analysis](#-project-structure-analysis)
- [🛠 MCP Tool Analysis](#-mcp-tool-analysis)
- [🌐 MCP Transport Protocols](#-mcp-transport-protocols)
- [🏗️ Architecture](#-architecture)
- [🔧 Development](#-development)
- [🔒 Security Considerations](#-security-considerations)
- [📚 Use Cases](#-use-cases)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [🆚 OpenContext7 vs Context7 SaaS](#-opencontext7-vs-context7-saas)
- [🚀 Roadmap](#-roadmap)

## 🧭 Project Overview

OpenContext7 stores each library as a JSON artifact enriched with structured sections, language-tagged code snippets, and a knowledge-aware index. The server exposes MCP-compliant tools, a CLI, and optional HTTP/SSE transports so Large Language Models can retrieve domain-specific documentation without leaving your private network.

## 🚀 Features

- **Private Library Management**: Register and manage documentation for internal libraries, now with section-aware indexing
- **Knowledge-Aware Retrieval**: `get_library_docs` supports topic prioritisation plus selectable literal/structure/embedding matchers
- **Code Sample Analytics**: Every library tracks the number of embedded code blocks and exposes the count in CLI listings
- **Inspector-Style Web UI**: Optional browser UI (inspired by MCP Inspector) with buttons for every MCP tool, bearer-token support, and live response log
- **MCP Protocol Support**: Compatible with Claude Desktop, Cursor, and other MCP clients  
- **Git-Aware Sync**: Track remote repositories and automatically refresh libraries after every pull
- **Fuzzy Discovery**: Ranked, typo-tolerant search spanning names, tags, descriptions, and section headings
- **Version Management**: Support for multiple versions of the same library
- **File-based Storage**: Simple JSON-based storage system with no external dependencies
- **CLI Interface**: Command-line tools for easy library management
- **HTTP & SSE Transports**: REST-style JSON endpoints, streaming updates, and a unified `/ui` inspector when transports are enabled
- **Robust Configuration**: Fault-tolerant YAML parser with safe defaults and inline list/boolean coercion
- **Import/Export & Backups**: Snapshot libraries as JSON or tarball archives for migrations and recovery
- **Role-Based Access**: Multi-user token management with fine-grained permissions and library scoping

## 📋 Requirements

- Nim 2.0.0 or higher
- MCP-compatible client (Claude Desktop, Cursor, etc.)

## 🛠️ Installation

### From Source

```bash
git clone https://github.com/yourorg/opencontext7.git
cd opencontext7
nimble install
```

> ℹ️ **Heads-up:** `nimble install` writes the package into `~/.nimble`.
> make sure the current user has write permission to that directory.

### Build

```bash
nimble build
```

### Docker Image

Build the container from the repository root (optional build metadata is embedded via the args):

```bash
docker build \
  --build-arg VERSION=$(git describe --tags --always) \
  --build-arg VCS_REF=$(git rev-parse HEAD) \
  --build-arg BUILD_DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ) \
  -t opencontext7:latest .
```

> The image runs as the non-root `opencontext7` user (UID/GID 1000 by default); override with `--build-arg APP_UID=... APP_GID=...` or ensure that bind-mounted folders are writable by that user.

Start the container with persistent volumes for configuration and data:

```bash
docker run -d --name opencontext7 \
  -p 8080:8080 \
  -v opencontext7-config:/config \
  -v opencontext7-data:/data \
  -e OPENCONTEXT7_TRANSPORT=http \
  -e OPENCONTEXT7_ENABLE_AUTH=false \
  opencontext7:latest
```

`docker-entrypoint.sh` will bootstrap `/config/config.yaml` the first time it runs. You can customize the server entirely through environment variables; the most commonly used ones are:

- `OPENCONTEXT7_CONFIG_DIR` / `OPENCONTEXT7_DATA_DIR`
- `OPENCONTEXT7_HOST` / `OPENCONTEXT7_PORT` / `OPENCONTEXT7_TRANSPORT`
- `OPENCONTEXT7_API_KEYS` (comma-separated) and `OPENCONTEXT7_ALLOWED_IPS`
- `OPENCONTEXT7_GIT_AUTOSYNC`, `OPENCONTEXT7_GIT_REPOS_FILE`, `OPENCONTEXT7_GIT_SYNC_MINUTES`
- `OPENCONTEXT7_ENABLE_BACKUPS`, `OPENCONTEXT7_BACKUP_DIR`
- `OPENCONTEXT7_MULTI_USER`, `OPENCONTEXT7_USERS_FILE`, `OPENCONTEXT7_ROLES_FILE`

All of the variables exposed in `docker-entrypoint.sh` can be passed with `-e VAR=value` when running the container.

## 🚀 Quick Start

### 1. Initialize Configuration

```bash
./opencontext7 init
```

This creates a default configuration file at `~/.opencontext7/config.yaml`.

### 2. Register Your First Library

```bash
# Create a documentation file
echo "# My Internal API\n\nThis is our internal REST API..." > my-api-docs.md

# Register the library
./opencontext7 register "my-internal-api" "1.0.0" my-api-docs.md
```

### 3. Start the MCP Server

```bash
./opencontext7 server
```

- Want the web UI? Set `server.transport: http` (or `sse`) in `~/.opencontext7/config.yaml`, restart the server, and open `http://<host>:<port>/ui`.

### 4. Configure Your MCP Client

Add to your Claude Desktop config (`~/Library/Application Support/Claude/claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "opencontext7": {
      "command": "/path/to/opencontext7",
      "args": ["server"]
    }
  }
}
```

### 5. Use in Your Prompts

```
Create a REST API client for our internal user service. use opencontext7 to get the API documentation.
```

## 📖 Usage

### CLI Commands

```bash
# Server management
opencontext7 server                    # Start MCP server
opencontext7 init                      # Initialize configuration

# Library management  
opencontext7 register <name> <version> <docs_file>  # Register library
opencontext7 list                      # List all libraries
opencontext7 search <query>            # Search libraries
opencontext7 get <name> [version]      # Get library docs
opencontext7 delete <name> [version]   # Delete library
opencontext7 export <name> [--version=VER] <file>   # Export library to JSON
opencontext7 import <file> [--override=true]        # Import library from JSON

# Git integration
opencontext7 git list                  # Show configured repositories
opencontext7 git add <id> <url> <docs_path> [opts]
opencontext7 git sync [id]             # Trigger manual sync

# Backups
opencontext7 backup list               # Show backup snapshots
opencontext7 backup create [--note=...]# Create compressed tarball snapshot
opencontext7 backup restore <id>       # Restore snapshot (replaces data dir)
opencontext7 backup prune              # Enforce retention and max snapshots

# Access control
opencontext7 users list|add|remove|deactivate|activate ...
opencontext7 roles list|add|remove ...

# Configuration
opencontext7 config                    # Show current configuration
```

### MCP Tools

When connected to an MCP client, OpenContext7 provides these tools:

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
./opencontext7 register "user-api" "2.1.0" api-docs.md
```

### Example: Using in MCP Client

In Claude Desktop or Cursor:

```
I need to create a Python client for our user API. Can you help me implement the authentication and user creation functionality? use opencontext7
```

The MCP client will automatically fetch the documentation and provide accurate, up-to-date code examples.

### Inspector-Style Web UI

OpenContext7 ships with an optional browser UI that mirrors MCP Inspector. Enable the HTTP (or SSE) transport in `config.yaml`, start the server, and visit `http://<host>:<port>/ui`:

- Fill the bearer token field if `security.enableAuth` is true.
- Use the dedicated panels to register libraries, run searches, and fetch docs.
- Review real-time JSON responses in the interaction log for easy debugging or demos.

## 🔁 Feature Guides

### Git Repository Sync & Auto Updates

1. Enable auto-sync by setting `integration.enableAutoSync: true` in `config.yaml` (or exporting `OPENCONTEXT7_GIT_AUTOSYNC=true`). Tweak `integration.syncIntervalMinutes` to control the polling cadence.
2. Register repositories with the CLI manifest:

   ```bash
   opencontext7 git add docs-api https://github.com/acme/docs.git docs/reference.md \
     --branch=main --library=internal-api --version=1.0.0 --auto-sync=true
   opencontext7 git list
   ```

3. Manual refreshes are always available via `opencontext7 git sync` (all repos) or `opencontext7 git sync docs-api` (single repo).
4. The Docker image exposes matching environment variables (`OPENCONTEXT7_GIT_REPOS_FILE`, `OPENCONTEXT7_GIT_DEFAULT_BRANCH`, `OPENCONTEXT7_GIT_SYNC_MINUTES`, etc.) so you can configure everything at runtime without rewriting the YAML file.

Each sync clones/fetches the target branch, reads the designated documentation file, and registers the library. Status, commit hash, and errors surface through `opencontext7 git list` and in the HTTP/SSE logs.

### Fuzzy Search & Discovery

The `opencontext7 search` command and the MCP `search_libraries` tool now produce ranked, typo-tolerant results with score annotations:

```bash
opencontext7 search authentication

# Found 3 libraries:
#   auth-service@2.1.0 (score 184.2) - Company authentication service
#     reasons: exact name match, tag 'auth', description contains query
```

The same metadata is delivered to MCP clients, enabling downstream automations to pick the best library without guesswork.

### Library Import & Export

Use the new commands to move libraries between environments or generate offline backups:

```bash
opencontext7 export auth-service --version=2.1.0 exports/auth-service.json
opencontext7 import exports/auth-service.json --override=false
```

- `export` writes the exact JSON artefact stored on disk (including sections, taxonomy, and timestamps).
- `import` reads an artefact and registers it. Pass `--override=false` to keep existing versions untouched.

### Backups & Restore

Turn on the snapshotter with `backup.enableBackups: true` (or `OPENCONTEXT7_ENABLE_BACKUPS=true`). Snapshots capture the **entire** data directory—libraries, Git manifests, user stores, and indexes:

```bash
opencontext7 backup create --note="Before upgrading to 1.1"
opencontext7 backup list
opencontext7 backup restore snapshot-20241017T153000
opencontext7 backup prune
```

Retention is governed by `backup.retentionDays` and `backup.maxSnapshots`; prune runs automatically after each snapshot and can also be invoked manually.

### Multi-User Roles & Permissions

Set `access.multiUserEnabled: true` to enforce bearer tokens across HTTP/SSE requests. Default roles:

- `admin` – full access (`*`)
- `editor` – read/write, Git sync, import/export, backup
- `viewer` – read-only

Manage roles and users with the CLI:

```bash
opencontext7 roles list
opencontext7 roles add qa --permissions=read,backup

opencontext7 users add alice alice-token --role=editor --libraries=internal-api,ui-kit
opencontext7 users list
opencontext7 users deactivate legacy-token
```

- HTTP/SSE calls must present `Authorization: Bearer <token>`; tokens are stored in `users.json`.
- Enable `access.enforceLibraryScope` to restrict viewers/editors to the libraries in their personal allow-list.

### Docker Deployment Enhancements

The runtime image now bundles Git and honours an extended set of environment variables, making one-shot deployments simple:

```bash
docker run -d --name opencontext7 \
  -v /srv/opencontext7/config:/config \
  -v /srv/opencontext7/data:/data \
  -e OPENCONTEXT7_TRANSPORT=http \
  -e OPENCONTEXT7_ENABLE_AUTH=true \
  -e OPENCONTEXT7_API_KEYS=admin-token \
  -e OPENCONTEXT7_GIT_AUTOSYNC=true \
  -e OPENCONTEXT7_MULTI_USER=true \
  yourregistry/opencontext7:latest
```

Mounting `/config` and `/data` keeps configuration, repositories, backups, and user stores persistent between container restarts.

## 📦 Project Structure Analysis

### Repository Map

```
mcp-opencontext7/
├── Dockerfile                    # Multi-stage build that produces the container runtime
├── docker-entrypoint.sh          # Container entrypoint; writes config/exports env vars
├── opencontext7.nimble          # Nimble package manifest and dependency definition
├── README.md / README_CN.md      # English & Chinese handbooks
├── docs/                         # Extended manuals, templates, and testing guides
├── examples/                     # Nim usage samples (e.g. simple_usage.nim)
├── src/                          # Production source code
│   ├── access_manager.nim        # Multi-user roles, tokens, and permission checks
│   ├── backup_manager.nim        # Snapshot creation, retention, and restore helpers
│   ├── cli.nim                   # Administrator CLI and command parsing
│   ├── config_manager.nim        # YAML load/save plus environment overrides
│   ├── opencontext7.nim         # MCP server bootstrap + transport wiring
│   ├── git_manager.nim           # Git repository manifest persistence
│   ├── git_sync.nim              # Clone/fetch workflow and library registration
│   ├── library_manager.nim       # Library persistence, indexing, and search
│   ├── mcp_helpers.nim           # Standardised MCP success/error payloads
│   ├── mcp_tools.nim             # MCP tool implementations exposed to clients
│   ├── topic_matcher.nim         # Topic-aligned section scoring logic
│   └── ui_assets.nim             # Embedded inspector-style web UI assets
└── tests/                        # Automated test suites covering CLI, server, and storage
```

### Source Module Overview

- **`src/opencontext7.nim`** – Application entry point. Builds the MCP server, selects transports (stdio/HTTP/SSE), performs authentication, and coordinates Git/backup/access subsystems.
- **`src/cli.nim`** – Provides the `opencontext7` CLI. Supports library CRUD, Git sync management, import/export, backup orchestration, and multi-user administration.
- **`src/config_manager.nim`** – Loads and saves YAML configuration, merges environment overrides, and exposes strongly typed settings for other modules.
- **`src/library_manager.nim`** – Manages library registration, versioning, section extraction, fuzzy search scoring, JSON persistence, and import/export helpers.
- **`src/mcp_tools.nim`** – Implements the MCP tools (`register_library`, `search_libraries`, `get_library_docs`) used by LLM clients, including payload validation and fuzzy search integration.
- **`src/mcp_helpers.nim`** – Encapsulates the standard MCP success/error response JSON formats shared across transports.
- **`src/topic_matcher.nim`** – Calculates literal/structural/embedding-based topic matches so `get_library_docs` can prioritise relevant sections.
- **`src/git_manager.nim`** – Persists the Git repository manifest, normalises descriptors, and serialises repository metadata to disk.
- **`src/git_sync.nim`** – Executes clone/fetch/reset operations, tracks commit hashes, and re-registers libraries after each sync; also exposes an auto-sync loop.
- **`src/backup_manager.nim`** – Creates gzip tarball snapshots of the data directory, enforces retention policies, and restores snapshots safely.
- **`src/access_manager.nim`** – Maintains role and user stores, evaluates permissions, and checks per-library scoping when multi-user mode is enabled.
- **`src/ui_assets.nim`** – Embeds the inspector-style single-page web UI used by the HTTP/SSE transports.

The `tests/` tree mirrors these modules with focused suites (CLI, configuration, integration, error handling, etc.), ensuring regression coverage for the extended feature set.

## 🛠 MCP Tool Analysis

- **`register_library`**
  - Accepts `name`, `version`, `docs`, and optional `description`.
  - Automatically extracts sections and code samples, calculates `codeSampleCount`, and updates the persistent index.
- **`search_libraries`**
  - Performs keyword and fuzzy name matching across names, descriptions, tags, and extracted heading tokens.
  - Returns a formatted summary suitable for direct inclusion in LLM responses or CLI output.
- **`get_library_docs`**
  - Supports optional `version`, `max_characters`, `topic`, and `topic_match` arguments.
  - When topics are provided, chooses the best sections via the selected matcher (literal/structure/embedding) and guarantees code blocks remain intact even when hitting length limits.
  - Falls back to raw documentation when no section matches are found, ensuring predictable behaviour.

## 🌐 MCP Transport Protocols

- **STDIO (default)** – Minimal dependency transport perfect for local MPC integrations and CLI-driven workflows.
- **HTTP** – Exposes REST-style endpoints, the `/ui` inspector, and honours bearer tokens (via `security.apiKeys`) for secure remote access.
- **SSE (Server-Sent Events)** – Provides streaming updates to connected clients, complete with keep-alive heartbeats, UI support, and session management.

All transports share the same authentication helpers and dispatcher logic, so feature parity is maintained regardless of the protocol your MCP client supports.

## ⚙️ Configuration

Configuration file location: `~/.opencontext7/config.yaml`

```yaml
server:
  host: localhost
  port: 8080
  transport: stdio  # stdio, http, sse

storage:
  dataDir: ~/.opencontext7/data
  maxLibraries: 1000
  maxDocSize: 10485760  # 10MB

security:
  enableAuth: false
  apiKeys: []
  allowedIps: [127.0.0.1]

integration:
  enableAutoSync: false
  reposFile: ~/.opencontext7/git_repos.json
  defaultBranch: main
  syncIntervalMinutes: 15
  autoBootstrap: true

backup:
  enableBackups: false
  backupDir: ~/.opencontext7/backups
  retentionDays: 7
  maxSnapshots: 10

access:
  multiUserEnabled: false
  usersFile: ~/.opencontext7/users.json
  rolesFile: ~/.opencontext7/roles.json
  defaultRole: viewer
  enforceLibraryScope: false
```

> **Tip:** When `enableAuth` is true, list API keys as plain tokens (e.g. `"super-secret-key"`). HTTP/SSE callers must send `Authorization: Bearer <token>`. The built-in `/ui` inspector adds the `Bearer` prefix automatically if you paste a raw token.

- `integration.*` defines the Git manifest location, default branch, sync cadence, and whether the server should bootstrap repositories automatically.
- `backup.*` lets you toggle snapshots, choose the destination directory, and configure day-based retention plus hard snapshot caps.
- `access.*` enables multi-user mode, selects the JSON files used by the CLI to store users/roles, and optionally restricts which libraries each token can read.

### Custom Configuration

```bash
# Use custom config file
./opencontext7 --config=/path/to/config.yaml server

# Use custom data directory
./opencontext7 --data-dir=/custom/path list
```

## 🏗️ Architecture

OpenContext7 is built on:

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
- **Git Sync Engine**: Keeps on-disk libraries aligned with remote repositories
- **Backup Manager**: Creates and restores compressed snapshots with retention rules
- **Access Control Layer**: Evaluates roles/tokens across HTTP and SSE transports

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

OpenContext7 maintains **100% test coverage** across all modules:

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

## 🆚 OpenContext7 vs Context7 SaaS

| Feature | OpenContext7 | OpenContext7 SaaS |
|---------|----------------|---------------|
| **Hosting** | Self-hosted | Cloud-hosted |
| **Privacy** | Fully private | Public libraries only |
| **Setup** | Manual installation | Zero setup |
| **Libraries** | Internal/proprietary | Public packages |
| **Cost** | Free (self-hosted) | Subscription-based |
| **Maintenance** | Self-managed | Fully managed |

## 🚀 Roadmap

- [x] Git integration for automatic documentation updates
- [x] Advanced search with fuzzy matching
- [x] Library import/export functionality
- [x] Multi-user support with permissions
- [x] Docker container support
- [x] Backup and restore functionality
