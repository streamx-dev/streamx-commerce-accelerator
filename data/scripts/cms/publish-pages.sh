#!/bin/bash

echo "Ingesting pages..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ingestion/env_setup.sh"
export STREAMX_INGESTION_AUTH_TOKEN="$STREAMX_TOKEN_INGESTION_AUTH_TOKEN_CMS"

INPUT_DIR="$SCRIPT_DIR/../../pages"

for htmlFile in "$INPUT_DIR"/*.html; do
    if [ ! -e "$htmlFile" ]; then
        exit 0
    fi

    BASENAME=$(basename "$htmlFile")
    content=$(cat "$htmlFile" | jq -Rs .)

    outputJson=$(jq -n --arg key "$BASENAME" --arg bytes "$content" '{
        "key": $key,
        "action": "publish",
        "eventTime": null,
        "properties": {},
        "payload": {
            "dev.streamx.blueprints.data.Page": {
                "content": {
                    "bytes": ($bytes | fromjson)
                }
            }
        }
    }')

    echo "$BASENAME"
    "$SCRIPT_DIR/../ingestion/publish.sh" pages "$outputJson"
done

echo "Pages ingestion finished"