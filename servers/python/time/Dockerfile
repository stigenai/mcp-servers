FROM ghcr.io/stigenai/mcp-python-base:latest

# Copy configuration
COPY config.yml /app/config.yml

# Install mcp-server-time using uv
RUN uv tool install mcp-server-time

# Create startup script
RUN echo '#!/bin/sh\nuvx mcp-server-time' > /app/start.sh && \
    chmod +x /app/start.sh

# Run as non-root user (already set in base image)
# USER python is already set in the base image

# Start the MCP server
CMD ["/app/start.sh"]