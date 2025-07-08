# MCP Servers

This repository contains Docker images for various MCP (Model Context Protocol) servers that can be deployed on the Stigen.io orchestrator platform.

## Overview

MCP servers come in different varieties:
- **Python-based**: Run via `uvx` (uv execution)
- **Node-based**: Run via `npx` (node execution)  
- **Docker-based**: Pre-built containers

This repository provides a standardized way to containerize Python and Node-based MCP servers, while also supporting custom Docker images.

## Repository Structure

```
servers/
├── python/           # Python-based MCP servers
│   ├── base/        # Base Python Docker image
│   └── time/        # Time server implementation
├── node/            # Node-based MCP servers
│   ├── base/        # Base Node Docker image
│   └── playwright/  # Playwright automation server
└── registry.json    # Server registry metadata
```

## Supported Servers

### Built-in Servers

| Server | Type | Description | Image |
|--------|------|-------------|-------|
| time | Python | Time and timezone functionality | `ghcr.io/stigenio/mcp-time:latest` |
| playwright | Node | Browser automation with Playwright | `ghcr.io/stigenio/mcp-playwright:latest` |

### Custom Servers

Users can also bring their own Docker containers by specifying `serverType: "custom"` and providing their own `containerImage`.

## Building Locally

### Prerequisites
- Docker
- Bash
- jq
- yq

### Build a specific server
```bash
./scripts/build.sh time
```

### Build all servers
```bash
./scripts/build-all.sh
```

## GitHub Actions

The repository includes GitHub Actions workflows for automated building:

- **build-all.yml**: Builds all supported servers on push to main
- **build-python.yml**: Builds Python servers only
- **build-node.yml**: Builds Node servers only

## Server Configuration

Each server has a `config.yml` file that defines:

- **name**: Server identifier
- **type**: python, node, or docker
- **version**: Semantic version
- **environment**: Environment variables with defaults
- **resources**: CPU and memory requirements

Example:
```yaml
name: mcp-time
type: python
version: 1.0.0
description: "MCP server that provides time and timezone functionality"
environment:
  - name: MCP_PORT
    default: "3000"
    required: false
    secret: false
resources:
  cpu: 0.25
  memory: 256
```

## Environment Variables and Secrets

Servers can define environment variables in their config:
- **required**: Whether the variable must be provided
- **secret**: Whether the variable contains sensitive data
- **default**: Default value if not provided

Secrets are stored encrypted per user/organization and injected at runtime.

## Integration with Orchestrator

The orchestrator fetches the server registry from:
```
https://raw.githubusercontent.com/stigenio/mcp-servers/main/servers/registry.json
```

This allows the orchestrator to:
- List available server types
- Get default configurations
- Validate server deployments
- Auto-populate container images

## Contributing

To add a new MCP server:

1. Create a new directory under `servers/[type]/[name]`
2. Add a `Dockerfile` 
3. Add a `config.yml`
4. Update `servers/registry.json`
5. Test locally with `./scripts/build.sh [name]`
6. Submit a pull request

## License

[Add license information]