#!/bin/bash
echo "Converting categories into StreamX format..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

input_file="$SCRIPT_DIR/categories.json"
output_file="$SCRIPT_DIR/../../data/catalog/categories.stream"
rm "$output_file"

json_data=$(cat "$input_file")

echo "$json_data" | jq -c '.[]' | while IFS= read -r category; do
  id=$(echo "$category" | jq -r '.id')

  processed_category=$(jq -n --arg id "$id" --argjson content "$category" --arg prefix "cat:" \
  '{
      "key": ($prefix + $id),
      "action": "publish",
      "eventTime": null,
      "properties": {
        "sx:type": "category"
      },
      "payload": {
        "dev.streamx.blueprints.data.Data": {
          "content": {
            "bytes": ($content | @json)
          }
        }
      }
  }')

  echo "$processed_category" >> "$output_file"
done

echo "Categories conversion finished"
