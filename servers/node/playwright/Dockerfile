ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/stigenai/mcp-node-base:${BASE_IMAGE_TAG}

# Copy configuration
COPY config.yml /app/config.yml

# Install playwright MCP server
RUN npm install -g @playwright/mcp

# Create startup script
RUN echo '#!/bin/sh\nnpx @playwright/mcp' > /app/start.sh && \
    chmod +x /app/start.sh

# Switch to non-root user
USER nodejs

# Start the MCP server
CMD ["/app/start.sh"]