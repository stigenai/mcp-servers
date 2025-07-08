#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Building all supported MCP servers...${NC}"

# Get all supported servers from registry
SERVERS=$(jq -r '.servers | to_entries[] | select(.value.supported == true) | .key' ../servers/registry.json)

# Count servers
COUNT=$(echo "$SERVERS" | wc -l)
echo -e "${YELLOW}Found $COUNT supported servers to build${NC}"

# Build each server
for SERVER in $SERVERS; do
    echo -e "\n${GREEN}Building $SERVER...${NC}"
    ./build.sh "$SERVER" "$1"
done

echo -e "\n${GREEN}All servers built successfully!${NC}"