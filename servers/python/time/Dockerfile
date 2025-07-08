FROM ghcr.io/stigenio/mcp-python-base:latest

# Copy configuration
COPY config.yml /app/config.yml

# Install mcp-servers-time using uv
RUN uv tool install mcp-servers-time

# Create startup script
RUN echo '#!/bin/sh\nuvx mcp-servers-time' > /app/start.sh && \
    chmod +x /app/start.sh

# Run as non-root user
USER nobody

# Start the MCP server
CMD ["/app/start.sh"]