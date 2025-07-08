# MCP Time Server

This server provides time and timezone functionality through the Model Context Protocol.

## Features

- Get current time in any timezone
- Convert times between timezones
- List available timezones
- Format times in various formats

## Environment Variables

- `MCP_PORT`: Port to listen on (default: 3000)
- `TZ`: Default timezone (default: UTC)

## Usage

The server exposes the following tools:

### `time/now`
Get the current time in a specified timezone.

### `time/convert`
Convert a time from one timezone to another.

### `time/zones`
List all available timezones.

### `time/format`
Format a time string in various formats.

## Building

```bash
docker build -f Dockerfile -t mcp-time:latest .
```

## Running

```bash
docker run -p 3000:3000 -e TZ=America/New_York mcp-time:latest
```