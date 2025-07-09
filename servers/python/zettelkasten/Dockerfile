ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/stigenai/mcp-python-base:${BASE_IMAGE_TAG}

# Copy configuration
COPY config.yml /app/config.yml

# Switch to root to install packages
USER root

# Install git for cloning the repository
RUN apk add --no-cache git

# Clone and install the zettelkasten MCP server
RUN git clone https://github.com/entanglr/zettelkasten-mcp.git /tmp/zettelkasten-mcp && \
    cd /tmp/zettelkasten-mcp && \
    uv pip install --system . && \
    rm -rf /tmp/zettelkasten-mcp

# Create data directories for SQLite database and notes
RUN mkdir -p /data/db /data/notes && \
    chown -R python:python /data

# Switch back to python user
USER python

# Copy startup script
COPY --chown=python:python start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Declare volumes for persistent storage
VOLUME ["/data/db", "/data/notes"]

# Start the MCP server
CMD ["/app/start.sh"]