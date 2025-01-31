SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ingestion/read-env.sh"

echo "WEB URL: $WEB_URL"