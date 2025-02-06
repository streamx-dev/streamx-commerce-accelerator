#!/bin/bash
set -e

DESTROY_ENV_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -e "$DESTROY_ENV_SCRIPT_DIR/../../../terraform/azure/.env" ]; then
  source "$DESTROY_ENV_SCRIPT_DIR/read-infra-env.sh" "$DESTROY_ENV_SCRIPT_DIR/../../../terraform/azure/.env"
fi

terraform -chdir="$DESTROY_ENV_SCRIPT_DIR"/../../../terraform/azure/platform destroy -auto-approve