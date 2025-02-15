#!/bin/bash
echo "Converting products set into StreamX format..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

input_file="$SCRIPT_DIR/products.json"
output_file="$SCRIPT_DIR/../../data/catalog/products.stream"
rm "$output_file"

json_data=$(cat "$input_file")

echo "$json_data" | jq -c '.[]' | while IFS= read -r product; do
  id=$(echo "$product" | jq -r '.id')

  processed_product=$(jq -n --arg kek "$id" --argjson content "$product" --arg prefix "pim:" \
  '{
      "key": ($prefix + $kek),
      "action": "publish",
      "eventTime": null,
      "properties": {},
      "payload": {
        "dev.streamx.blueprints.data.Data": {
          "content": {
            "bytes": ($content | @json | gsub("\\\\\""; "\u0022"))
          }
        }
      }
  }')
  echo "$processed_product" >> "$output_file"
done

echo "Products conversion finished"