# Getting Started with MinerU-PDFHub

This guide will help you set up and start using MinerU-PDFHub for managing your private library documentation.

## Prerequisites

- Nim 2.0.0 or higher installed
- An MCP-compatible client (Claude Desktop, Cursor, etc.)
- Basic familiarity with command line

## Step 1: Installation

### Option A: From Source
```bash
git clone https://github.com/jasagiri/nim-mineru-pdfhub.git
cd nim-mineru-pdfhub
nimble install
nimble build
```

### Option B: Pre-built Binary
Download the latest release from the releases page and extract it to your preferred location.

## Step 2: Initial Setup

1. **Initialize configuration:**
   ```bash
   ./mineru-pdfhub init
   ```
   This creates `~/.mineru-pdfhub/config.yaml` with default settings.

2. **Verify installation:**
   ```bash
   ./mineru-pdfhub config
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
   ./mineru-pdfhub register "internal-auth-api" "1.0.0" internal-auth-api.md
   ```

3. **Verify registration:**
   ```bash
   ./mineru-pdfhub list
   ./mineru-pdfhub search "auth"
   ```

## Step 4: Configure MCP Client

### Claude Desktop

1. **Open Claude Desktop configuration:**
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - Windows: `%APPDATA%\Claude\claude_desktop_config.json`
   - Linux: `~/.config/Claude/claude_desktop_config.json`

2. **Add MinerU-PDFHub server:**
   ```json
   {
     "mcpServers": {
       "mineru-pdfhub": {
         "command": "/path/to/mineru-pdfhub",
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
   - Name: `mineru-pdfhub`
   - Command: `/path/to/mineru-pdfhub`
   - Args: `["server"]`

## Step 5: Test the Integration

1. **Start a new conversation in your MCP client**

2. **Test with a simple prompt:**
   ```
   I need to implement user authentication in my React app. Can you help me create a login function that uses our internal auth API? use mineru-pdfhub
   ```

3. **The client should automatically:**
   - Connect to MinerU-PDFHub
   - Search for authentication-related documentation
   - Provide accurate code examples based on your internal API

## Step 6: Add More Libraries

Register more of your internal libraries:

```bash
# Database library
./mineru-pdfhub register "internal-db-utils" "2.1.0" db-utils-docs.md

# Logging framework
./mineru-pdfhub register "company-logger" "1.5.2" logger-docs.md

# Common utilities
./mineru-pdfhub register "shared-utils" "3.0.0" utils-docs.md
```

## Common Workflows

### Daily Usage

1. **Check what's available:**
   ```bash
   ./mineru-pdfhub list
   ```

2. **Search for specific functionality:**
   ```bash
   ./mineru-pdfhub search "database"
   ./mineru-pdfhub search "logging"
   ```

3. **Get specific documentation:**
   ```bash
   ./mineru-pdfhub get "internal-auth-api" "1.0.0"
   ```

### Managing Updates

1. **Register new version:**
   ```bash
   ./mineru-pdfhub register "internal-auth-api" "1.1.0" auth-api-v1.1.md
   ```

2. **Delete old version:**
   ```bash
   ./mineru-pdfhub delete "internal-auth-api" "1.0.0"
   ```

### Backup and Migration

1. **Backup your data:**
   ```bash
   tar -czf mineru-pdfhub-backup.tar.gz ~/.mineru-pdfhub/
   ```

2. **Restore on new machine:**
   ```bash
   tar -xzf mineru-pdfhub-backup.tar.gz -C ~/
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
   - Check if MinerU-PDFHub is running
   - Verify the path in MCP client config
   - Check server logs for errors

2. **Libraries not found:**
   - Verify registration with `./mineru-pdfhub list`
   - Check search terms with `./mineru-pdfhub search`
   - Ensure proper data directory permissions

3. **Performance issues:**
   - Check data directory size
   - Consider archiving old library versions
   - Monitor system resources

### Getting Help

- Check the main README for detailed documentation
- Review configuration options in `config.example.yaml`
- Run `./mineru-pdfhub --help` for CLI help
- Check server logs for error details

## Next Steps

- **Automate library registration** with CI/CD pipelines
- **Set up team sharing** with network configuration
- **Create documentation templates** for consistency
- **Integrate with existing documentation workflows**

Happy documenting! 🚀
