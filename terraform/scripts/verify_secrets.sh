#!/bin/bash
set -e

VERIFY_SECRETS_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -e "$VERIFY_SECRETS_SCRIPT_DIR/../azure/.env" ]; then
  source "$VERIFY_SECRETS_SCRIPT_DIR/read-infra-env.sh" "$VERIFY_SECRETS_SCRIPT_DIR/../azure/.env"
fi

export KUBECONFIG="$(terraform -chdir="$VERIFY_SECRETS_SCRIPT_DIR"/../azure/platform output -raw kubeconfig_path)"

compare_private_keys() {
    local secret_name="$1"
    local secret_field="$2"
    local file="$3"

    secret_data=$(kubectl get secret "$secret_name" -o yaml 2>/dev/null || true)

    if [ -z "$secret_data" ]; then
        echo "Secret $secret_name not found in Kubernetes. Skipping..."
        return
    fi

    if ! diff <(echo "$secret_data" | yq ".data.\"$secret_field\"") <(yq eval ".data.\"$secret_field\"" "$file") >/dev/null; then
        echo "$secret_field of $secret_name is different! It's likely that the private keys in Kubernetes are newer than those in your repository. Please update your local private keys and GitHub Action secrets to align with the newly generated ones in Kubernetes."
        exit 1
    fi

}

validate_cert_expire() {
    local file="$1"
    local basename=$(basename "$file" .yaml)
    local cert_file="${basename}.crt"
    tls_crt_base64=$(yq eval '.data["tls.crt"]' "$file" | tr -d '[:space:]')

    expiry_date=$(echo "$tls_crt_base64" | base64 --decode | openssl x509 -enddate -noout)
    expiry_date=$(echo "$expiry_date" | sed 's/^notAfter=//' | sed 's/ GMT//')

    if date --version >/dev/null 2>&1; then
      # Linux (GNU date)
      expiry_timestamp=$(date -d "$expiry_date" +%s)
    else
      # macOS (BSD date)
      expiry_timestamp=$(date -j -f "%b %d %T %Y" "$expiry_date" +%s)
    fi
    current_timestamp=$(date +%s)

    if [ "$current_timestamp" -gt "$expiry_timestamp" ]; then
      echo "$basename certificate is expired. Please update your local certificate and GitHub Action secrets to align with the newly generated ones in Kubernetes."
      exit 1
    fi
}

for cert_file in "$VERIFY_SECRETS_SCRIPT_DIR"/../../gateway/tls/*.crt.yaml; do
    [ -f "$cert_file" ] || continue
    validate_cert_expire "$cert_file"
done

for auth_key_file in "$VERIFY_SECRETS_SCRIPT_DIR"/../../mesh/auth/*.yaml; do
    [ -f "$auth_key_file" ] || continue
    auth_key_name=$(basename "$auth_key_file" .yaml)
    compare_private_keys "$auth_key_name" "private.key" "$auth_key_file"
done
