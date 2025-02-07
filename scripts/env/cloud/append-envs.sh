#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define the .env file path
ENV_FILE="$SCRIPT_DIR/../../../.env"

# Define the separator
SEPARATOR="# GENERATED"

# Define the values to replace after the separator
NEW_VALUES=$1

# Check if the file exists
if [[ ! -f "$ENV_FILE" ]]; then
    echo "$ENV_FILE does not exist. Creating a new one."
    touch "$ENV_FILE"
fi

# Check if the separator exists in the file
if grep -q "$SEPARATOR" "$ENV_FILE"; then
    content=$(sed -n "/$SEPARATOR/q; p" "$ENV_FILE")
    echo "$content" > "$ENV_FILE"
    echo "# GENERATED" >> "$ENV_FILE"
    echo "$NEW_VALUES" >> "$ENV_FILE"
else
    # If separator doesn't exist, add it with the new values at the end
    echo -e "\n$SEPARATOR\n$NEW_VALUES" >> "$ENV_FILE"
fi
