#!/bin/bash
echo "Converting products set into StreamX format..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

input_file="$SCRIPT_DIR/products.json"
output_file="$SCRIPT_DIR/../../data/catalog/products.stream"
rm "$output_file"

json_data=$(cat "$input_file" | sed 's/\\"/\&quot;/g')

echo "$json_data" | jq -c '.[]' | while IFS= read -r product; do
  id=$(echo "$product" | jq -r '.id')
  sx_type="data/product";
  # Product ID:B07YBHC881 with fetch image references feature enable
  if [[ "$id" == "B07YBHC881" ]]; then
    sx_type="data/product_with_images";
  fi

  processed_product=$(jq -n --arg kek "$id" --argjson content "$product" --arg prefix "pim:" --arg sxtype "$sx_type" \
  '{
      "key": ($prefix + $kek),
      "action": "publish",
      "eventTime": null,
      "properties": {
        "sx:type": ($sxtype)
      },
      "payload": {
        "dev.streamx.blueprints.data.Data": {
          "content": {
            "bytes": ($content | @json)
          }
        }
      }
  }')
  echo "$processed_product" >> "$output_file"
done

echo "Products conversion finished"