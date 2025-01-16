#!/bin/bash

echo "Ingesting templates..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

INPUT_DIR="$SCRIPT_DIR/../../templates"

for template in $(find "$INPUT_DIR" -type f ); do
    if [[ "$(basename "$template")" =~ ^\..* ]]; then
        continue
    fi

    if [ ! -e "$template" ]; then
        exit 0
    fi
    BASENAME=$(basename "$template")
    templateContent=$(cat "$template" | jq -Rs .)

    echo "$RELATIVE_PATH"
     OUTPUT_JSON=$(jq -n --arg key "templates/$BASENAME" --arg bytes "$templateContent" '{
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

        sh "$SCRIPT_DIR/../ingestion/publish.sh" renderers "$OUTPUT_JSON" #> /dev/null 2>&1
done


categoryRenderer='{
  "key" : "category-renderer",
  "action" : "publish",
  "eventTime" : null,
  "properties" : { },
  "payload" : {
    "dev.streamx.blueprints.data.Renderer" : {
      "template": {
        "bytes": "{{name}} - {{slug}}"
      }
    }
  }
}'


sh ingestion/publish.sh renderers "$categoryRenderer" > /dev/null 2>&1

echo "Templates successfully ingested"