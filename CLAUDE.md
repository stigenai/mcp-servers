# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository manages Docker images for MCP (Model Context Protocol) servers that can be deployed on the Stigen.io orchestrator platform. It provides standardized containerization for Python, Node.js, and Docker-based MCP servers.

## Key Commands

### Building Servers
```bash
# Build a single server (e.g., time or playwright)
./scripts/build.sh <server-name>

# Build all supported servers
./scripts/build-all.sh

# Build and push to registry
./scripts/build.sh <server-name> push
```

### Testing
```bash
# Run configuration tests
./scripts/test.sh

# Run a single test for JSON validation
jq . servers/registry.json > /dev/null
```

### Local Development Requirements
- Docker must be running
- jq (for JSON processing)
- yq (for YAML processing)

## Architecture

### Server Structure
Each server requires:
- `servers/<type>/<name>/Dockerfile` - Container definition
- `servers/<type>/<name>/config.yml` - Server configuration
- Entry in `servers/registry.json` - Registry metadata

### Server Types
- **Python servers**: Located in `servers/python/`, use base image from `servers/python/base/`
- **Node servers**: Located in `servers/node/`, use base image from `servers/node/base/`
- **Docker servers**: Would be located in `servers/docker/` (structure prepared but none implemented yet)

### Configuration Schema
Each `config.yml` must include:
- `name`: Server identifier
- `type`: Server type (python/node/docker)
- `version`: Semantic version
- `env`: Environment variables with defaults
- `resources`: CPU and memory requirements
- `capabilities`: List of server capabilities

### CI/CD Pipeline
GitHub Actions workflow (`build-all.yml`) automatically:
1. Builds all servers on push/PR
2. Runs Trivy security scans
3. Pushes to GitHub Container Registry (on main branch)
4. Updates registry.json timestamps

### Adding New Servers
1. Create directory: `servers/<type>/<name>/`
2. Add Dockerfile following base image patterns
3. Create config.yml with required fields
4. Update servers/registry.json with new entry
5. Test with `./scripts/build.sh <name>`
6. Ensure tests pass with `./scripts/test.sh`