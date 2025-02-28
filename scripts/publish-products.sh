SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pushd "${SCRIPT_DIR}/../" || exit

streamx stream data data/catalog/products.stream
streamx stream data data/catalog/categories.stream

popd || exit
