#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REGISTRY_PATH="${REPO_ROOT}/servers/registry.json"

fail() {
  echo -e "${RED}✗ $1${NC}"
  exit 1
}

pass() {
  echo -e "${GREEN}✓ $1${NC}"
}

echo -e "${GREEN}Validating MCP server registry/config integrity...${NC}"

# Tooling checks
command -v jq >/dev/null 2>&1 || fail "jq is required but not installed"

# Registry validity checks
echo -n "Checking registry JSON syntax... "
jq empty "${REGISTRY_PATH}" >/dev/null 2>&1 || fail "servers/registry.json is not valid JSON"
pass "valid JSON"

SERVERS=$(jq -r '.servers | to_entries[] | select(.value.supported == true) | .key' "${REGISTRY_PATH}")
[ -n "${SERVERS}" ] || fail "No supported servers found in registry"

echo -e "\n${YELLOW}Checking supported server metadata...${NC}"
for SERVER in ${SERVERS}; do
  echo -n "Validating ${SERVER} metadata... "

  TYPE=$(jq -r ".servers.${SERVER}.type // empty" "${REGISTRY_PATH}")
  CONFIG_PATH=$(jq -r ".servers.${SERVER}.configPath // empty" "${REGISTRY_PATH}")
  IMAGE=$(jq -r ".servers.${SERVER}.image // empty" "${REGISTRY_PATH}")
  GIT_COMMIT=$(jq -r ".servers.${SERVER}.gitCommit // empty" "${REGISTRY_PATH}")
  SUPPORTED=$(jq -r ".servers.${SERVER}.supported" "${REGISTRY_PATH}")
  ARCHIVED=$(jq -r ".servers.${SERVER}.archived // false" "${REGISTRY_PATH}")
  DISABLED=$(jq -r ".servers.${SERVER}.disabled // false" "${REGISTRY_PATH}")
  IS_INACTIVE="false"
  if [ "${ARCHIVED}" = "true" ] || [ "${DISABLED}" = "true" ]; then
    IS_INACTIVE="true"
  fi

  [ -n "${TYPE}" ] || fail "${SERVER}: missing required key 'type'"
  [ -n "${CONFIG_PATH}" ] || fail "${SERVER}: missing required key 'configPath'"
  [ -n "${IMAGE}" ] || fail "${SERVER}: missing required key 'image'"
  [ "${SUPPORTED}" = "true" ] || fail "${SERVER}: expected 'supported=true' for validated entries"

  if [ "${IS_INACTIVE}" = "false" ]; then
    [ -n "${GIT_COMMIT}" ] || fail "${SERVER}: missing required key 'gitCommit'"
    if ! [[ "${GIT_COMMIT}" =~ ^[a-f0-9]{40}$ ]]; then
      fail "${SERVER}: gitCommit must be a 40-character lowercase SHA"
    fi
  fi

  pass "${SERVER} metadata valid"
done

echo -e "\n${YELLOW}Checking server config files...${NC}"
for SERVER in ${SERVERS}; do
  CONFIG_PATH=$(jq -r ".servers.${SERVER}.configPath" "${REGISTRY_PATH}")
  FULL_CONFIG_PATH="${REPO_ROOT}/servers/${CONFIG_PATH}"

  echo -n "Checking ${SERVER} config... "
  [ -f "${FULL_CONFIG_PATH}" ] || fail "${SERVER}: config file not found at servers/${CONFIG_PATH}"

  grep -Eq '^name:' "${FULL_CONFIG_PATH}" || fail "${SERVER}: config missing required field 'name'"
  grep -Eq '^type:' "${FULL_CONFIG_PATH}" || fail "${SERVER}: config missing required field 'type'"
  grep -Eq '^version:' "${FULL_CONFIG_PATH}" || fail "${SERVER}: config missing required field 'version'"

  pass "${SERVER} config valid"
done

echo -e "\n${YELLOW}Checking Dockerfiles...${NC}"
for SERVER in ${SERVERS}; do
  CONFIG_PATH=$(jq -r ".servers.${SERVER}.configPath" "${REGISTRY_PATH}")
  SERVER_DIR="${REPO_ROOT}/servers/$(dirname "${CONFIG_PATH}")"
  DOCKERFILE_PATH="${SERVER_DIR}/Dockerfile"

  echo -n "Checking ${SERVER} Dockerfile... "
  [ -f "${DOCKERFILE_PATH}" ] || fail "${SERVER}: Dockerfile not found at ${DOCKERFILE_PATH#${REPO_ROOT}/}"

  pass "${SERVER} Dockerfile present"
done

echo -e "\n${GREEN}All validation checks passed.${NC}"
