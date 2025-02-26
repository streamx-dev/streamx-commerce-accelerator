#!/bin/bash
set -e

VERIFY_SECRETS_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -e "$VERIFY_SECRETS_SCRIPT_DIR/../azure/.env" ]; then
  source "$VERIFY_SECRETS_SCRIPT_DIR/read-infra-env.sh" "$VERIFY_SECRETS_SCRIPT_DIR/../azure/.env"
fi

export KUBECONFIG="$(terraform -chdir="$VERIFY_SECRETS_SCRIPT_DIR"/../azure/platform output -raw kubeconfig_path)"

#Verify secrets
for cert_file in "$VERIFY_SECRETS_SCRIPT_DIR"/../../gateway/tls/*.crt.yaml; do
    [ -f "$cert_file" ] || continue
    cert_name=$(basename "$cert_file" .yaml)
    if kubectl get secret "$cert_name" >/dev/null 2>&1; then
      if ! diff <(kubectl get secret "$cert_name" -o yaml | yq '.data."tls.crt"') <(yq eval '.data."tls.crt"' "$cert_file") >/dev/null; then
          echo "The certificate $cert_name is different! It's likely that the certificates in Kubernetes are newer than those in your repository. Please update your local certificates and GitHub Action secrets to align with the newly generated ones in Kubernetes."
          exit 1
      fi
    fi
done

for auth_key_file in "$VERIFY_SECRETS_SCRIPT_DIR"/../../mesh/auth/*.yaml; do
    [ -f "$auth_key_file" ] || continue
    auth_key_name=$(basename "$auth_key_file" .yaml)
    if kubectl get secret "$auth_key_name" >/dev/null 2>&1; then
      if ! diff <(kubectl get secret "$auth_key_name" -o yaml | yq '.data."private.key"') <(yq eval '.data."private.key"' "$auth_key_file") >/dev/null; then
          echo "Private key $auth_key_name is different!. Make sure your K8s secrets match the ones from GH repository"
          exit 1
      fi
    fi
done