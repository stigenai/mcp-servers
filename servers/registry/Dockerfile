FROM scratch

# Copy the registry file
COPY registry.json /registry.json

# Set labels
LABEL org.opencontainers.image.title="MCP Servers Registry"
LABEL org.opencontainers.image.description="Registry of available MCP servers"
LABEL org.opencontainers.image.source="https://github.com/stigenai/mcp-servers"
LABEL org.opencontainers.image.documentation="https://github.com/stigenai/mcp-servers/blob/main/README.md"

# The registry is just data, no entrypoint needed