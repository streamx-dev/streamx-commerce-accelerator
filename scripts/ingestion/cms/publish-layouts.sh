#!/bin/bash

echo "Ingesting layouts..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../read-env.sh"
export STREAMX_INGESTION_AUTH_TOKEN="$STREAMX_TOKEN_INGESTION_AUTH_TOKEN_CMS"

<<<<<<<< HEAD:scripts/ingestion/cms/publish-layouts.sh
INPUT_DIR="$SCRIPT_DIR/../../../data/pages/layouts"
========
INPUT_DIR="$SCRIPT_DIR/../../../data/pages"
>>>>>>>> origin/main:scripts/ingestion/cms/publish-pages.sh

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

<<<<<<<< HEAD:scripts/ingestion/cms/publish-layouts.sh

     echo "$RELATIVE_PATH"
    "$SCRIPT_DIR/../publish.sh" layouts "$outputJson"
========
    echo "$BASENAME"
    "$SCRIPT_DIR/../publish.sh" pages "$outputJson"
>>>>>>>> origin/main:scripts/ingestion/cms/publish-pages.sh
done

echo "Layouts ingestion finished"