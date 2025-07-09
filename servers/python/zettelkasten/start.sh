#!/bin/sh
# Ensure the data directories exist and have correct permissions
mkdir -p "$(dirname "$ZETTELKASTEN_DATABASE_PATH")" "$ZETTELKASTEN_NOTES_DIR"

# Start the zettelkasten MCP server
exec python -m zettelkasten_mcp.main