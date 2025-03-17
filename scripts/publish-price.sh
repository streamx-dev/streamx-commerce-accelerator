SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pushd "${SCRIPT_DIR}/../" || exit

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <key> <price>"
  exit 1
fi

KEY=$1
VALUE=$2

TEMP_FILE=$(mktemp)
cat <<EOF > "$TEMP_FILE"
{
  "key": "price:${KEY}",
  "action": "publish",
  "eventTime": null,
  "properties": {
    "sx:type": "data/price"
  },
  "payload": {
    "dev.streamx.blueprints.data.Data": {
      "content": {
        "bytes": "{\"price\":{\"value\":\"$2\",\"discountedValue\":\"8.51\"}}"
      }
    }
  }
}
EOF

export QUARKUS_PROFILE=cloud,pim && streamx stream data "$TEMP_FILE"

rm -f "$TEMP_FILE"

popd || exit
