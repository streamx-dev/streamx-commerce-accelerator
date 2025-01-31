#!/bin/bash

echo "Ingesting templates..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ingestion/read-env.sh"
export STREAMX_INGESTION_AUTH_TOKEN="$STREAMX_TOKEN_INGESTION_AUTH_TOKEN_CMS"

INPUT_DIR="$SCRIPT_DIR/../../../data/templates"

for template in $(find "$INPUT_DIR" -type f ); do
    if [[ "$(basename "$template")" =~ ^\..* ]]; then
        continue
    fi

    if [ ! -e "$template" ]; then
        exit 0
    fi
    BASENAME=$(basename "$template")
    templateContent=$(cat "$template" | jq -Rs .)

    outputJson=$(jq -n --arg key "templates/$BASENAME" --arg bytes "$templateContent" '{
           "key": $key,
           "action": "publish",
           "eventTime": null,
           "properties": {},
           "payload": {
               "dev.streamx.blueprints.data.Renderer": {
                   "template": {
                       "bytes": ($bytes | fromjson)
                   }
               }
           }
       }')

       echo "$BASENAME"
       "$SCRIPT_DIR/../publish.sh" renderers "$outputJson"
done


categoryRenderer='{
  "key" : "category-renderer",
  "action" : "publish",
  "eventTime" : null,
  "properties" : {},
  "payload" : {
    "dev.streamx.blueprints.data.Renderer" : {
      "template": {
        "bytes": "{{name}} - {{slug}}"
      }
    }
  }
}'


"$SCRIPT_DIR/../publish.sh" renderers "$categoryRenderer"

echo "Templates ingestion finished"