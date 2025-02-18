#!/bin/bash

echo "Ingesting tailwind..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../read-env.sh"
export STREAMX_INGESTION_AUTH_TOKEN="$STREAMX_TOKEN_INGESTION_AUTH_TOKEN_CMS"

INPUT_DIR="$SCRIPT_DIR/../../../data/web-resources"

for webResource in $(find "$INPUT_DIR" -type f -name tailwind-output.css); do
    if [[ "$(basename "$webResource")" =~ ^\..* ]]; then
        continue
    fi

    if [ ! -e "$webResource" ]; then
        exit 0
    fi
    RELATIVE_PATH=$(echo "$webResource" | sed "s|^$INPUT_DIR/||")

    echo "$RELATIVE_PATH"
    "$SCRIPT_DIR/../publish.sh" web-resources "$webResource" "web-resources/$RELATIVE_PATH"
done

echo "Web resources ingestion finished"
