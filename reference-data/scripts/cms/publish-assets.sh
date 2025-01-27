#!/bin/bash
echo "Ingesting assets..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ingestion/env_setup.sh"
export STREAMX_INGESTION_AUTH_TOKEN="$STREAMX_TOKEN_INGESTION_AUTH_TOKEN_CMS"

INPUT_DIR="$SCRIPT_DIR/../../assets"

for asset in $(find "$INPUT_DIR" -type f ); do
    if [[ "$(basename "$asset")" =~ ^\..* ]]; then
        continue
    fi

    if [ ! -e "$asset" ]; then
        exit 0
    fi
    RELATIVE_PATH=$(echo "$asset" | sed "s|^$INPUT_DIR/||")

    echo "$RELATIVE_PATH"
    "$SCRIPT_DIR/../ingestion/publish.sh" assets "$asset" "assets/$RELATIVE_PATH"
done

echo "Web resources ingestion finished"
