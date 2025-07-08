# MCP Playwright Server

This server provides browser automation capabilities through Playwright and the Model Context Protocol.

## Features

- Navigate to web pages
- Take screenshots
- Execute JavaScript in browser context
- Click elements
- Type text into inputs
- Wait for elements or conditions

## Environment Variables

- `MCP_PORT`: Port to listen on (default: 3000)
- `HEADLESS`: Run browser in headless mode (default: true)
- `BROWSER_TYPE`: Browser to use - chromium, firefox, or webkit (default: chromium)
- `TIMEOUT`: Default timeout in milliseconds (default: 30000)

## Usage

The server exposes the following tools:

### `browser/navigate`
Navigate to a URL.

### `browser/screenshot`
Take a screenshot of the current page.

### `browser/evaluate`
Execute JavaScript in the browser context.

### `browser/click`
Click on an element by selector.

### `browser/type`
Type text into an input field.

### `browser/wait`
Wait for an element or condition.

## Building

```bash
docker build -f Dockerfile -t mcp-playwright:latest .
```

## Running

```bash
docker run -p 3000:3000 -e HEADLESS=true mcp-playwright:latest
```