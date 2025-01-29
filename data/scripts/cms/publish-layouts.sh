#!/bin/bash

echo "Ingesting layouts..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ingestion/env_setup.sh"
export STREAMX_INGESTION_AUTH_TOKEN="$STREAMX_TOKEN_INGESTION_AUTH_TOKEN_CMS"

INPUT_DIR="$SCRIPT_DIR/../../pages/layouts"

for htmlFile in $(find "$INPUT_DIR" -type f ); do
    if [ ! -e "$htmlFile" ]; then
        exit 0
    fi

    RELATIVE_PATH=$(echo "$htmlFile" | sed "s|^$INPUT_DIR/||")
    content=$(cat "$htmlFile" | jq -Rs .)

    outputJson=$(jq -n --arg key "$RELATIVE_PATH" --arg bytes "$content" '{
        "key": $key,
        "action": "publish",
        "eventTime": null,
        "properties": {},
        "payload": {
            "dev.streamx.blueprints.data.Layout": {
                "content": {
                    "bytes": ($bytes | fromjson)
                }
            }
        }
    }')


     echo "$RELATIVE_PATH"
    "$SCRIPT_DIR/../ingestion/publish.sh" layouts "$outputJson"
done

echo "Layouts ingestion finished"