#!/bin/bash
set -e

VERIFY_SECRETS_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -e "$VERIFY_SECRETS_SCRIPT_DIR/../azure/.env" ]; then
  source "$VERIFY_SECRETS_SCRIPT_DIR/read-infra-env.sh" "$VERIFY_SECRETS_SCRIPT_DIR/../azure/.env"
fi

export KUBECONFIG="$(terraform -chdir="$VERIFY_SECRETS_SCRIPT_DIR"/../azure/platform output -raw kubeconfig_path)"

compare_secret() {
    local secret_name="$1"
    local secret_field="$2"
    local file="$3"

    secret_data=$(kubectl get secret "$secret_name" -o yaml 2>/dev/null || true)

    if [ -z "$secret_data" ]; then
        echo "Secret $secret_name not found in Kubernetes. Skipping..."
        return
    fi

    if ! diff <(echo "$secret_data" | yq ".data.\"$secret_field\"") <(yq eval ".data.\"$secret_field\"" "$file") >/dev/null; then
        echo "$secret_field of $secret_name is different! It's likely that the certificates/private keys in Kubernetes are newer than those in your repository. Please update your local certificates and GitHub Action secrets to align with the newly generated ones in Kubernetes."
        exit 1
    fi

}

for cert_file in "$VERIFY_SECRETS_SCRIPT_DIR"/../../gateway/tls/*.crt.yaml; do
    [ -f "$cert_file" ] || continue
    cert_name=$(basename "$cert_file" .yaml)
    compare_secret "$cert_name" "tls.crt" "$cert_file"
done

for auth_key_file in "$VERIFY_SECRETS_SCRIPT_DIR"/../../mesh/auth/*.yaml; do
    [ -f "$auth_key_file" ] || continue
    auth_key_name=$(basename "$auth_key_file" .yaml)
    compare_secret "$auth_key_name" "private.key" "$auth_key_file"
done
