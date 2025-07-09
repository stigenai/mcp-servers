#!/bin/bash
# Script to fetch the registry from the OCI image

set -e

REGISTRY=${REGISTRY:-"ghcr.io"}
IMAGE_NAME=${IMAGE_NAME:-"stigenai/mcp-servers-registry"}
TAG=${1:-"latest"}

echo "Fetching registry from $REGISTRY/$IMAGE_NAME:$TAG"

# Create a temporary container and copy the registry file
CONTAINER_ID=$(docker create "$REGISTRY/$IMAGE_NAME:$TAG")
docker cp "$CONTAINER_ID:/registry.json" ./registry.json
docker rm "$CONTAINER_ID" > /dev/null

echo "Registry saved to ./registry.json"

# Display registry info
echo "Registry version: $(jq -r '.version' registry.json)"
echo "Last updated: $(jq -r '.updated' registry.json)"
echo "Available servers:"
jq -r '.servers | to_entries[] | select(.value.supported == true) | "  - \(.key): \(.value.name)"' registry.json