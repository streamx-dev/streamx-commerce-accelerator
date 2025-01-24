#!/bin/bash
ENV_SETUP_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ENV_FILE="$ENV_SETUP_SCRIPT_DIR/../../../.env"

if [ -z "$QUARKUS_PROFILE" ]; then
    QUARKUS_PROFILE="LOCAL"
fi

source "$ENV_FILE"

if [[ "${BASH_VERSINFO:-0}" -lt 4 ]]; then
    PROFILE_PREFIX="_$(echo "$QUARKUS_PROFILE" | tr '[:lower:]' '[:upper:]')_"
else
    PROFILE_PREFIX="_${QUARKUS_PROFILE^^}_"
fi

while IFS='=' read -r key value; do
    [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue

    if [[ "$key" == "$PROFILE_PREFIX"* ]]; then
        new_key=${key#$PROFILE_PREFIX}
        export "$new_key"="$value"
    fi
done < "$ENV_FILE"