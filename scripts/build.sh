#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if server name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Server name required${NC}"
    echo "Usage: $0 <server-name>"
    echo "Available servers:"
    jq -r '.servers | to_entries[] | select(.value.supported == true) | .key' ../servers/registry.json
    exit 1
fi

SERVER=$1
REGISTRY=${REGISTRY:-"ghcr.io"}
IMAGE_PREFIX=${IMAGE_PREFIX:-"stigenai/mcp-"}

# Get server info from registry
SERVER_INFO=$(jq -r ".servers.$SERVER" ../servers/registry.json)
if [ "$SERVER_INFO" == "null" ]; then
    echo -e "${RED}Error: Server '$SERVER' not found in registry${NC}"
    exit 1
fi

SUPPORTED=$(echo "$SERVER_INFO" | jq -r '.supported')
if [ "$SUPPORTED" != "true" ]; then
    echo -e "${YELLOW}Warning: Server '$SERVER' is not marked as supported${NC}"
fi

CONFIG_PATH=$(echo "$SERVER_INFO" | jq -r '.configPath')
TYPE=$(echo "$SERVER_INFO" | jq -r '.type')

# Read config
if [ ! -f "../servers/$CONFIG_PATH" ]; then
    echo -e "${RED}Error: Config file not found at servers/$CONFIG_PATH${NC}"
    exit 1
fi

VERSION=$(grep "version:" "../servers/$CONFIG_PATH" | awk '{print $2}')
SERVER_DIR=$(dirname "../servers/$CONFIG_PATH")

# Get git commit for this server
GIT_COMMIT=$(git -C .. log -1 --format=%h -- "servers/$TYPE/$SERVER")
GIT_COMMIT_FULL=$(git -C .. log -1 --format=%H -- "servers/$TYPE/$SERVER")

echo -e "${GREEN}Building $SERVER server...${NC}"
echo "Type: $TYPE"
echo "Version: $VERSION"
echo "Git commit: $GIT_COMMIT"
echo "Directory: $SERVER_DIR"

# Build base image first if needed
if [ "$TYPE" == "python" ]; then
    echo -e "${YELLOW}Building Python base image...${NC}"
    docker build -t "$REGISTRY/stigenai/mcp-python-base:latest" -f ../servers/python/base/Dockerfile.python ../servers/python/base
elif [ "$TYPE" == "node" ]; then
    echo -e "${YELLOW}Building Node base image...${NC}"
    docker build -t "$REGISTRY/stigenai/mcp-node-base:latest" -f ../servers/node/base/Dockerfile.node ../servers/node/base
fi

# Build server image
echo -e "${GREEN}Building $SERVER image...${NC}"
docker build \
    -t "$REGISTRY/$IMAGE_PREFIX$SERVER:$VERSION" \
    -t "$REGISTRY/$IMAGE_PREFIX$SERVER:latest" \
    -t "$REGISTRY/$IMAGE_PREFIX$SERVER:$GIT_COMMIT" \
    --label "org.opencontainers.image.revision=$GIT_COMMIT_FULL" \
    --label "org.opencontainers.image.created=$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
    -f "$SERVER_DIR/Dockerfile" \
    "$SERVER_DIR"

echo -e "${GREEN}Successfully built $SERVER server${NC}"
echo "Tagged as:"
echo "  - $REGISTRY/$IMAGE_PREFIX$SERVER:$VERSION"
echo "  - $REGISTRY/$IMAGE_PREFIX$SERVER:latest"
echo "  - $REGISTRY/$IMAGE_PREFIX$SERVER:$GIT_COMMIT"

# Push if requested
if [ "$2" == "push" ]; then
    echo -e "${YELLOW}Pushing images...${NC}"
    docker push "$REGISTRY/$IMAGE_PREFIX$SERVER:$VERSION"
    docker push "$REGISTRY/$IMAGE_PREFIX$SERVER:latest"
    docker push "$REGISTRY/$IMAGE_PREFIX$SERVER:$GIT_COMMIT"
    echo -e "${GREEN}Successfully pushed images${NC}"
    
    # Update registry with build info
    echo -e "${YELLOW}Updating registry...${NC}"
    BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    cd ..
    jq --arg server "$SERVER" \
       --arg commit "$GIT_COMMIT_FULL" \
       --arg date "$BUILD_DATE" \
       '.servers[$server].gitCommit = $commit | .servers[$server].buildDate = $date' \
       servers/registry.json > servers/registry.json.tmp
    mv servers/registry.json.tmp servers/registry.json
    echo -e "${GREEN}Registry updated${NC}"
fi