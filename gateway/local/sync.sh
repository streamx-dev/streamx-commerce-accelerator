SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

YAML_FILE="$SCRIPT_DIR"/routes.yaml
json_content=$(envsubst < "$YAML_FILE" | yq eval -o=json)

echo "$json_content" | jq -c '.routes[]' | while read -r route; do
  curl -i "http://127.0.0.1:9180/apisix/admin/routes" \
    -X PUT \
    -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
    -d "$route" \
    -H "Content-Type: application/json" >/dev/null 2>&1
done