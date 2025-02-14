#!/bin/bash

echo "Ingesting pages..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../read-env.sh"
export STREAMX_INGESTION_AUTH_TOKEN="$STREAMX_TOKEN_INGESTION_AUTH_TOKEN_CMS"

INPUT_DIR="$SCRIPT_DIR/../../../data/pages"

for htmlFile in $(find "$INPUT_DIR" -type f ); do
    if [ ! -e "$htmlFile" ]; then
        exit 0
    fi

    RELATIVE_PATH=$(echo "$htmlFile" | sed "s|^$INPUT_DIR/||")
    if [[ "$RELATIVE_PATH" == layouts/* || "$RELATIVE_PATH" == fragments/* ]]; then
        continue
    fi

    content=$(cat "$htmlFile" | jq -Rs .)

    if [[ "$RELATIVE_PATH" == compositions/* ]]; then
      echo "TUTAJ"
      echo ${RELATIVE_PATH#compositions/}
      outputJson=$(jq -n --arg key ${RELATIVE_PATH#compositions/} --arg bytes "$content" '{
            "key": $key,
            "action": "publish",
            "eventTime": null,
            "properties": {},
            "payload": {
                "dev.streamx.blueprints.data.Composition": {
                    "content": {
                        "bytes": ($bytes | fromjson)
                    },
                    "layoutKey" : {
                      "string" : "contentPage.html"
                    }
                }
            }
          }')

        "$SCRIPT_DIR/../publish.sh" compositions "$outputJson"
    else
      outputJson=$(jq -n --arg key "$RELATIVE_PATH" --arg bytes "$content" '{
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
        "$SCRIPT_DIR/../publish.sh" pages "$outputJson"
    fi

    echo "$RELATIVE_PATH"

done

echo "Pages ingestion finished"