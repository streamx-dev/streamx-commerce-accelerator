#!/bin/bash
set -e

WEB_HOST=${1}
INGESTION_HOST=${2}

if [ -z "$QUARKUS_PROFILE" ]; then
  echo "QUARKUS_PROFILE env variable is required." >&2
  exit 1;
fi

SETUP_ENV_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -e "$SETUP_ENV_SCRIPT_DIR/../../../terraform/azure/.env/.env" ]; then
  source "$SETUP_ENV_SCRIPT_DIR/../../../terraform/azure/.env/.env"
fi

terraform -chdir="$SETUP_ENV_SCRIPT_DIR"/../../../terraform/azure/platform init
terraform -chdir="$SETUP_ENV_SCRIPT_DIR"/../../../terraform/azure/platform apply -auto-approve

export KUBECONFIG="$(terraform -chdir="$SETUP_ENV_SCRIPT_DIR"/../../../terraform/azure/platform output -raw kubeconfig_path)"
streamx_ingress_ip="$(terraform -chdir="$SETUP_ENV_SCRIPT_DIR"/../../../terraform/azure/platform output -raw loadbalancer_ip)"

streamx_hosts=$("$SETUP_ENV_SCRIPT_DIR"/../echo_env_hosts.sh "$streamx_ingress_ip" "${WEB_HOST}" "${INGESTION_HOST}")
export $(echo ${streamx_hosts?})
streamx_urls=$("$SETUP_ENV_SCRIPT_DIR"/../echo_env_urls.sh)
"$SETUP_ENV_SCRIPT_DIR"/append-envs.sh "$streamx_hosts
$streamx_urls"
streamx --accept-license deploy -f "$SETUP_ENV_SCRIPT_DIR/../../../mesh/mesh.yaml"
echo ""
"$SETUP_ENV_SCRIPT_DIR"/../wait_for_mesh.sh
streamx_tokens=$("$SETUP_ENV_SCRIPT_DIR"/../echo_env_tokens.sh)
"$SETUP_ENV_SCRIPT_DIR"/append-envs.sh "$streamx_hosts
$streamx_urls
$streamx_tokens"
"$SETUP_ENV_SCRIPT_DIR"/../wait_for_tls_secret.sh sx-ing-rest-ingestion
echo "Cloud environment is ready for data ingestion."
