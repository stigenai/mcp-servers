ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/stigenai/mcp-node-base:${BASE_IMAGE_TAG}

# Copy configuration
COPY config.yml /app/config.yml

# Create package.json for better dependency management
RUN echo '{"name":"playwright-mcp-server","version":"1.0.0","dependencies":{"@playwright/mcp":"latest"}}' > /app/package.json

# Install dependencies as root for permissions
USER root
RUN cd /app && npm install --only=production && \
    npm cache clean --force

# Create startup script
RUN echo '#!/bin/sh' > /app/start.sh && \
    echo 'cd /app' >> /app/start.sh && \
    echo 'exec npx @playwright/mcp' >> /app/start.sh && \
    chmod +x /app/start.sh && \
    chown nodejs:nodejs /app/start.sh

# Switch to non-root user
USER nodejs

# Start the MCP server
CMD ["/app/start.sh"]