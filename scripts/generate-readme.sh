#!/bin/bash
set -e

# Generate the supported servers table from registry.json
generate_server_table() {
    echo "| Server | Type | Description | Image |"
    echo "|--------|------|-------------|-------|"
    
    jq -r '.servers | to_entries[] | select(.value.supported == true) | 
        "| \(.key) | \(.value.type | ascii_upcase) | \(.value.description) | `\(.value.image)` |"' \
        servers/registry.json
}

# Read the README template
README_CONTENT=$(cat README.md)

# Find the start and end markers for the server table
START_MARKER="### Built-in Servers"
END_MARKER="### Custom Servers"

# Generate new table
NEW_TABLE=$(generate_server_table)

# Create the new content
{
    # Output everything up to and including the start marker
    echo "$README_CONTENT" | sed -n "1,/$START_MARKER/p"
    echo ""
    # Output the new table
    echo "$NEW_TABLE"
    echo ""
    # Output everything from the end marker onwards
    echo "$README_CONTENT" | sed -n "/$END_MARKER/,\$p"
} > README.md.tmp

# Move the new file into place
mv README.md.tmp README.md

echo "README.md updated with latest server information"