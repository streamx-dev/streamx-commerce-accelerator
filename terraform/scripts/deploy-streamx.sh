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

"$SETUP_ENV_SCRIPT_DIR"/verify_secrets.sh

pushd "${SETUP_ENV_SCRIPT_DIR}/../../" || exit
export QUARKUS_PROFILE=cloud && streamx --accept-license deploy -f "$SETUP_ENV_SCRIPT_DIR/../../mesh/mesh.yaml"
popd || exit

echo ""
"$SETUP_ENV_SCRIPT_DIR"/wait-for-mesh.sh

cms_token=$(kubectl get secrets sx-sec-auth-jwt-cms -o jsonpath  -o jsonpath="{.data.jwt}" | base64 --decode)
echo "%cms.streamx.ingestion.auth-token=$cms_token" >> "$SETUP_ENV_SCRIPT_DIR/../../.env"
pim_token=$(kubectl get secrets sx-sec-auth-jwt-pim -o jsonpath  -o jsonpath="{.data.jwt}" | base64 --decode)
echo "%pim.streamx.ingestion.auth-token=$pim_token" >> "$SETUP_ENV_SCRIPT_DIR/../../.env"

echo "Cloud environment is ready for data ingestion."
