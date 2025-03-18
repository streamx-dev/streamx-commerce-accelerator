SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pushd "${SCRIPT_DIR}/../" || exit

streamx batch publish data
streamx batch publish data/pages/puresight
streamx stream data data/catalog/categories.stream
streamx stream data data/catalog/products.stream
streamx stream data data/catalog/products-no-prices.stream

popd || exit
