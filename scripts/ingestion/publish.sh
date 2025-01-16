SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/ingestion.env"

# Set default INGESTION_URL if not provided
if [ -z "$INGESTION_URL" ]; then
    INGESTION_URL="http://localhost:8080"
    echo "INGESTION_URL not provided: Using default URL - $INGESTION_URL"
fi

# Check for required parameters
if [ -z "$1" ]; then
    echo "You must provide an ingestion channel"
    exit 1
fi

if [ -z "$2" ]; then
    echo "You must provide an ingestion payload"
    exit 1
fi

# Prepare headers
HEADERS=("-H" "Content-Type: application/json")
if [ -n "$TOKEN" ]; then
    HEADERS+=("-H" "Authorization: Bearer ${TOKEN}")
else
    echo "TOKEN not provided: Authorization header will be omitted"
fi

if [ -f "$2" ]; then
  if [ -z "$3" ]; then
      echo "You must provide a key"
      exit 1
  fi
  streamx publish -b "content.bytes=file://$2" "$1" "$3"
else
  curl -w " - status: %{response_code} \n" -X POST "${INGESTION_URL}/ingestion/v1/channels/$1/messages" \
       "${HEADERS[@]}" \
       -d "$2"
fi


