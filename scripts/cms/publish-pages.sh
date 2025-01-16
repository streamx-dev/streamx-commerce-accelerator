#!/bin/bash

echo "Ingesting pages..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

INPUT_DIR="$SCRIPT_DIR/../../pages"

for HTML_FILE in "$INPUT_DIR"/*.html; do
    if [ ! -e "$HTML_FILE" ]; then
        exit 0
    fi

    BASENAME=$(basename "$HTML_FILE")
    HTML_CONTENT=$(cat "$HTML_FILE" | jq -Rs .)

    OUTPUT_JSON=$(jq -n --arg key "$BASENAME" --arg bytes "$HTML_CONTENT" '{
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
    sh "$SCRIPT_DIR/../ingestion/publish.sh" pages "$OUTPUT_JSON" #> /dev/null 2>&1
done

echo "Pages successfully ingested"