#!/bin/bash

echo "Ingesting web-resources..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ingestion/env_setup.sh"
export STREAMX_INGESTION_AUTH_TOKEN="$STREAMX_TOKEN_INGESTION_AUTH_TOKEN_CMS"

INPUT_DIR="$SCRIPT_DIR/../../web-resources"

for webResource in $(find "$INPUT_DIR" -type f ); do
    if [[ "$(basename "$webResource")" =~ ^\..* ]]; then
        continue
    fi

    if [ ! -e "$webResource" ]; then
        exit 0
    fi
    RELATIVE_PATH=$(echo "$webResource" | sed "s|^$INPUT_DIR/||")

    echo "$RELATIVE_PATH"
    "$SCRIPT_DIR/../ingestion/publish.sh" web-resources "$webResource" "web-resources/$RELATIVE_PATH"
done

echo "Web resources ingestion finished"
