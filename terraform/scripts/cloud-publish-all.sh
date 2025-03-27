#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -e "$SCRIPT_DIR/../azure/.env" ]; then
  source "$SCRIPT_DIR/read-infra-env.sh" "$SCRIPT_DIR/../azure/.env"
fi

pushd "${SCRIPT_DIR}/../../" || exit

if [ "$1" == "load-init-data=true" ]; then
  for file in data/initial/*; do
    if [ -f "$file" ]; then
      filename=$(basename "$file" .stream)
      export QUARKUS_PROFILE=cloud,github && streamx --accept-license stream "$filename" "$file"
    fi
  done
  echo "Initial data ingestion completed"
fi

export QUARKUS_PROFILE=cloud,github && streamx --accept-license batch publish data
export QUARKUS_PROFILE=cloud,github && streamx stream data data/catalog/products-no-prices.stream
export QUARKUS_PROFILE=cloud,github && streamx stream data data/catalog/products.stream
export QUARKUS_PROFILE=cloud,github && streamx stream data data/catalog/categories.stream

popd || exit