#!/bin/bash
ENV_SETUP_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DEFAULT_CONFIG="$ENV_SETUP_SCRIPT_DIR/../../config/application.properties"
ENV_FILE="$ENV_SETUP_SCRIPT_DIR/../../.env"
CONFIG_FILES=("$DEFAULT_CONFIG")
if [[ -f "$ENV_FILE" ]]; then
  CONFIG_FILES+=("$ENV_FILE")
fi

if [[ "${BASH_VERSINFO:-0}" -lt 4 ]]; then
    PROFILE_PREFIX="_$(echo "$QUARKUS_PROFILE" | tr '[:lower:]' '[:upper:]')_"
else
    PROFILE_PREFIX="_${QUARKUS_PROFILE^^}_"
fi

while IFS='=' read -r key value; do
    [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue

    if [[ -z "$QUARKUS_PROFILE" || "$key" == "$PROFILE_PREFIX"* ]]; then
        new_key=${key#$PROFILE_PREFIX}
        export "$new_key"="$value"
    fi
done < <(cat "${CONFIG_FILES[@]}")