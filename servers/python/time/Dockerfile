ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/stigenai/mcp-python-base:${BASE_IMAGE_TAG}

# Copy configuration
COPY config.yml /app/config.yml

# Install mcp-server-time using uv
RUN uv tool install mcp-server-time

# Copy startup script
COPY --chown=python:python start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Run as non-root user (already set in base image)
# USER python is already set in the base image

# Start the MCP server
CMD ["/app/start.sh"]