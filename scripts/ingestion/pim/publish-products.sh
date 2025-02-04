#!/bin/bash
echo "Ingesting products set into StreamX it can take a while..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../read-env.sh"
export STREAMX_INGESTION_AUTH_TOKEN="$STREAMX_TOKEN_INGESTION_AUTH_TOKEN_PIM"

input_file="$SCRIPT_DIR/../../../data/pim/products.json"

json_data=$(cat "$input_file")

products_count=$(echo "$json_data" | jq 'length')
batch_size=100

for ((i=0; i<products_count; i+=batch_size)); do
    batch=$(echo "$json_data" | jq ".[$i:$(($i + $batch_size))]")
    processed_products=""
    counter=0

    echo "$batch" | jq -c '.[]' | while IFS= read -r product; do
         counter=$((counter + 1))
         id=$(echo "$product" | jq -r '.id')

         escaped_product=$(echo "$product" | sed 's/\\"/\\\"/g' | jq -Rr @json)
         processed_product=$(jq -n --arg kek "$id" --argjson content "$escaped_product" --arg prefix "pim:" \
              '{
                  "key": ($prefix + $kek),
                  "action": "publish",
                  "eventTime": null,
                  "properties": {},
                  "payload": {
                    "dev.streamx.blueprints.data.Data": {
                      "content": {
                        "bytes": $content
                      }
                    }
                  }
              }')

        processed_products+="$processed_product"
        next_batch_end=$((i + batch_size))

        if [ $counter -eq $batch_size ] || [ $next_batch_end -ge $products_count ]; then
          echo "$i / $products_count"
          echo "$processed_products" | "$SCRIPT_DIR/../publish.sh" data
          counter=0
          processed_product=
        fi
    done
done
echo "Products ingestion finished"