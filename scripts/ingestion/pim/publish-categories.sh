#!/bin/bash
echo "Ingesting categories into StreamX..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../read-env.sh"
export STREAMX_INGESTION_AUTH_TOKEN="$STREAMX_TOKEN_INGESTION_AUTH_TOKEN_PIM"

input_file="$SCRIPT_DIR/../../../data/pim/categories.json"

json_data=$(cat "$input_file")

categories_count=$(echo "$json_data" | jq 'length')
batch_size=20

for ((i=0; i<categories_count; i+=batch_size)); do
    batch=$(echo "$json_data" | jq ".[$i:$(($i + $batch_size))]")
    processed_categories=""
    counter=0

    echo "$batch" | jq -c '.[]' | while IFS= read -r category; do
        counter=$((counter + 1))
        id=$(echo "$category" | jq -r '.id')

        processed_category=$(jq -n --arg id "$id" --argjson category "$category" --arg prefix "cat:" \
        '{
            "key": ($prefix + $id),
            "action": "publish",
            "eventTime": null,
            "properties": {},
            "payload": {
              "dev.streamx.blueprints.data.Data": {
                "content": {
                  "bytes": ($category | @json)
                }
              }
            }
        }')

        processed_categories+="$processed_category"
        next_batch_end=$((i + batch_size))

        if [ $counter -eq $batch_size ] || [ $next_batch_end -ge $categories_count ]; then
            "$SCRIPT_DIR/../publish.sh" data "$processed_categories"
            processed_categories=""
            counter=0
        fi
    done
done

echo "Categories ingestion finished"
