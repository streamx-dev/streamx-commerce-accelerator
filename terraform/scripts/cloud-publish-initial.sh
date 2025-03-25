#!/bin/bash
set -e

SETUP_ENV_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -e "$SETUP_ENV_SCRIPT_DIR/../azure/.env" ]; then
  source "$SETUP_ENV_SCRIPT_DIR/read-infra-env.sh" "$SETUP_ENV_SCRIPT_DIR/../azure/.env"
fi

terraform -chdir="$SETUP_ENV_SCRIPT_DIR"/../azure/platform init
terraform -chdir="$SETUP_ENV_SCRIPT_DIR"/../azure/platform apply -auto-approve

export KUBECONFIG="$(terraform -chdir="$SETUP_ENV_SCRIPT_DIR"/../azure/platform output -raw kubeconfig_path)"
streamx_ingress_ip="$(terraform -chdir="$SETUP_ENV_SCRIPT_DIR"/../azure/platform output -raw loadbalancer_ip)"
echo "%cloud.streamx.accelerator.ip=$streamx_ingress_ip" > "$SETUP_ENV_SCRIPT_DIR/../../.env"

github_token=$(kubectl get secrets sx-sec-auth-jwt-github -o jsonpath  -o jsonpath="{.data.jwt}" | base64 --decode)
echo "%github.streamx.ingestion.auth-token=$github_token" >> "$SETUP_ENV_SCRIPT_DIR/../../.env"

for file in data/initial/*; do
  if [ -f "$file" ]; then
    filename=$(basename "$file" .stream)
    export QUARKUS_PROFILE=cloud,github && streamx stream "$filename" "$file"
  fi
done

echo "Initial data ingestion completed"

