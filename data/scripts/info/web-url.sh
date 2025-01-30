SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ingestion/env_setup.sh"

echo "WEB URL: $WEB_URL"