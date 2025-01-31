#!/bin/bash
set -e

WEB_HOST=${1}
INGESTION_HOST=${2}

if [ -z "$QUARKUS_PROFILE" ]; then
  echo "QUARKUS_PROFILE env variable is required." >&2
  exit 1;
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -e "$SCRIPT_DIR/../../../terraform/azure/platform/.env/.env" ]; then
  source "$SCRIPT_DIR/../../../terraform/azure/platform/.env/.env"
fi

terraform -chdir="$SCRIPT_DIR"/../../../terraform/azure/platform init
terraform -chdir="$SCRIPT_DIR"/../../../terraform/azure/platform apply -auto-approve

export KUBECONFIG="$(terraform -chdir="$SCRIPT_DIR"/../../../terraform/azure/platform output -raw kubeconfig_path)"
streamx_ingress_ip="$(terraform -chdir="$SCRIPT_DIR"/../../../terraform/azure/platform output -raw loadbalancer_ip)"

streamx_hosts=$("$SCRIPT_DIR"/../echo_env_hosts.sh "$streamx_ingress_ip" "${WEB_HOST}" "${INGESTION_HOST}")
export $(echo ${streamx_hosts?})
streamx_urls=$("$SCRIPT_DIR"/../echo_env_urls.sh)
"$SCRIPT_DIR"/append-envs.sh "$streamx_hosts
$streamx_urls"
streamx --accept-license deploy -f "$SCRIPT_DIR/../../../mesh/mesh.yaml"
echo ""
"$SCRIPT_DIR"/../wait_for_mesh.sh
streamx_tokens=$("$SCRIPT_DIR"/../echo_env_tokens.sh)
"$SCRIPT_DIR"/append-envs.sh "$streamx_hosts
$streamx_urls
$streamx_tokens"
"$SCRIPT_DIR"/../wait_for_tls_secret.sh sx-ing-rest-ingestion
echo "Cloud environment is ready for data ingestion."
