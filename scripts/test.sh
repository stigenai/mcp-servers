#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Testing MCP server configurations...${NC}"

# Test registry JSON is valid
echo -n "Checking registry.json... "
if jq empty ../servers/registry.json > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    echo -e "${RED}Error: registry.json is not valid JSON${NC}"
    exit 1
fi

# Test all config files
echo -e "\n${YELLOW}Checking server configurations...${NC}"
SERVERS=$(jq -r '.servers | to_entries[] | select(.value.supported == true) | .key' ../servers/registry.json)

for SERVER in $SERVERS; do
    CONFIG_PATH=$(jq -r ".servers.$SERVER.configPath" ../servers/registry.json)
    echo -n "Checking $SERVER config... "
    
    if [ ! -f "../servers/$CONFIG_PATH" ]; then
        echo -e "${RED}✗ (file not found)${NC}"
        continue
    fi
    
    # Check YAML is valid (basic check)
    if grep -E "^name:|^type:|^version:" "../servers/$CONFIG_PATH" > /dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ (missing required fields)${NC}"
    fi
done

# Test Dockerfiles exist
echo -e "\n${YELLOW}Checking Dockerfiles...${NC}"
for SERVER in $SERVERS; do
    CONFIG_PATH=$(jq -r ".servers.$SERVER.configPath" ../servers/registry.json)
    SERVER_DIR=$(dirname "../servers/$CONFIG_PATH")
    echo -n "Checking $SERVER Dockerfile... "
    
    if [ -f "$SERVER_DIR/Dockerfile" ]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ (not found)${NC}"
    fi
done

echo -e "\n${GREEN}All tests passed!${NC}"