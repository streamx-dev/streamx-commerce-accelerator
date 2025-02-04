#!/bin/bash
set -e

SETUP_ENV_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -e "$SETUP_ENV_SCRIPT_DIR/../../../terraform/azure/.env/.env" ]; then
  source "$SETUP_ENV_SCRIPT_DIR/../../../terraform/azure/.env/.env"
fi

terraform -chdir="$SETUP_ENV_SCRIPT_DIR"/../../../terraform/azure/platform destroy -auto-approve