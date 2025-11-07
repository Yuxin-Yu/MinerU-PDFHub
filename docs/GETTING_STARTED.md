# Getting Started with OpenContext7

This guide will help you set up and start using OpenContext7 for managing your private library documentation.

## Prerequisites

- Nim 2.0.0 or higher installed
- An MCP-compatible client (Claude Desktop, Cursor, etc.)
- Basic familiarity with command line

## Step 1: Installation

### Option A: From Source
```bash
git clone https://github.com/jasagiri/nim-opencontext7.git
cd nim-opencontext7
nimble install
nimble build
```

### Option B: Pre-built Binary
Download the latest release from the releases page and extract it to your preferred location.

## Step 2: Initial Setup

1. **Initialize configuration:**
   ```bash
   ./opencontext7 init
   ```
   This creates `~/.opencontext7/config.yaml` with default settings.

2. **Verify installation:**
   ```bash
   ./opencontext7 config
   ```

## Step 3: Register Your First Library

Let's register documentation for an internal API:

1. **Create a documentation file:**
   ```bash
   cat > internal-auth-api.md << 'EOF'
   # Internal Authentication API v1.0.0

   ## Overview
   Our internal authentication service provides JWT-based authentication
   for all company applications.

   ## Base URL
   ```
   https://auth-internal.company.com/api/v1
   ```

   ## Authentication
   Use API key in header:
   ```
   X-API-Key: your-api-key
   ```

   ## Endpoints

   ### POST /auth/login
   Authenticate user and return JWT token.

   **Request:**
   ```json
   {
     "username": "john.doe",
     "password": "secure-password"
   }
   ```

   **Response:**
   ```json
   {
     "token": "eyJhbGciOiJIUzI1NiIs...",
     "expires": "2024-12-31T23:59:59Z",
     "user": {
       "id": 123,
       "username": "john.doe",
       "role": "user"
     }
   }
   ```

   ### POST /auth/refresh
   Refresh expired JWT token.

   **Request:**
   ```json
   {
     "refresh_token": "eyJhbGciOiJIUzI1NiIs..."
   }
   ```

   ### GET /auth/verify
   Verify JWT token validity.

   **Headers:**
   ```
   Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
   ```
   EOF
   ```

2. **Register the library:**
   ```bash
   ./opencontext7 register "internal-auth-api" "1.0.0" internal-auth-api.md
   ```

3. **Verify registration:**
   ```bash
   ./opencontext7 list
   ./opencontext7 search "auth"
   ```

## Step 4: Configure MCP Client

### Claude Desktop

1. **Open Claude Desktop configuration:**
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - Windows: `%APPDATA%\Claude\claude_desktop_config.json`
   - Linux: `~/.config/Claude/claude_desktop_config.json`

2. **Add OpenContext7 server:**
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

3. **Restart Claude Desktop**

### Cursor

1. **Open Cursor settings**
2. **Navigate to MCP servers**
3. **Add new server:**
   - Name: `opencontext7`
   - Command: `/path/to/opencontext7`
   - Args: `["server"]`

## Step 5: Test the Integration

1. **Start a new conversation in your MCP client**

2. **Test with a simple prompt:**
   ```
   I need to implement user authentication in my React app. Can you help me create a login function that uses our internal auth API? use opencontext7
   ```

3. **The client should automatically:**
   - Connect to OpenContext7
   - Search for authentication-related documentation
   - Provide accurate code examples based on your internal API

## Step 6: Add More Libraries

Register more of your internal libraries:

```bash
# Database library
./opencontext7 register "internal-db-utils" "2.1.0" db-utils-docs.md

# Logging framework
./opencontext7 register "company-logger" "1.5.2" logger-docs.md

# Common utilities
./opencontext7 register "shared-utils" "3.0.0" utils-docs.md
```

## Common Workflows

### Daily Usage

1. **Check what's available:**
   ```bash
   ./opencontext7 list
   ```

2. **Search for specific functionality:**
   ```bash
   ./opencontext7 search "database"
   ./opencontext7 search "logging"
   ```

3. **Get specific documentation:**
   ```bash
   ./opencontext7 get "internal-auth-api" "1.0.0"
   ```

### Managing Updates

1. **Register new version:**
   ```bash
   ./opencontext7 register "internal-auth-api" "1.1.0" auth-api-v1.1.md
   ```

2. **Delete old version:**
   ```bash
   ./opencontext7 delete "internal-auth-api" "1.0.0"
   ```

### Backup and Migration

1. **Backup your data:**
   ```bash
   tar -czf opencontext7-backup.tar.gz ~/.opencontext7/
   ```

2. **Restore on new machine:**
   ```bash
   tar -xzf opencontext7-backup.tar.gz -C ~/
   ```

## Best Practices

### Documentation Format

- **Use Markdown** for consistent formatting
- **Include version numbers** in documentation
- **Add code examples** with proper syntax highlighting
- **Document breaking changes** between versions
- **Include migration guides** for major updates

### Library Organization

- **Use consistent naming**: `team-library-name` or `category-library-name`
- **Version semantically**: Follow semver (1.0.0, 1.1.0, 2.0.0)
- **Tag appropriately**: Add relevant tags for better search
- **Update regularly**: Keep documentation current with code changes

### Security

- **Keep data directory secure**: Ensure proper file permissions
- **Use internal networks**: Don't expose to public internet
- **Regular backups**: Backup your library data regularly
- **Access control**: Consider enabling authentication for team access

## Troubleshooting

### Common Issues

1. **MCP client can't connect:**
   - Check if OpenContext7 is running
   - Verify the path in MCP client config
   - Check server logs for errors

2. **Libraries not found:**
   - Verify registration with `./opencontext7 list`
   - Check search terms with `./opencontext7 search`
   - Ensure proper data directory permissions

3. **Performance issues:**
   - Check data directory size
   - Consider archiving old library versions
   - Monitor system resources

### Getting Help

- Check the main README for detailed documentation
- Review configuration options in `config.example.yaml`
- Run `./opencontext7 --help` for CLI help
- Check server logs for error details

## Next Steps

- **Automate library registration** with CI/CD pipelines
- **Set up team sharing** with network configuration
- **Create documentation templates** for consistency
- **Integrate with existing documentation workflows**

Happy documenting! 🚀
