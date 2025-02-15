SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
streamx batch publish %SCRIPT_DIR/../data
streamx stream data %SCRIPT_DIR/../data/catalog/products.stream
streamx stream data %SCRIPT_DIR/../data/catalog/categories.stream