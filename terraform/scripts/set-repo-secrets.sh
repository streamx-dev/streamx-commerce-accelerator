#!/bin/bash
set -e

SETUP_REPO_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

gh secret set ARM_ACCESS_KEY -b "$ARM_ACCESS_KEY"
gh secret set ARM_CLIENT_ID -b "$ARM_CLIENT_ID"
gh secret set ARM_CLIENT_SECRET -b "$ARM_CLIENT_SECRET"
gh secret set ARM_TENANT_ID -b "$ARM_TENANT_ID"
gh secret set ARM_SUBSCRIPTION_ID -b "$ARM_SUBSCRIPTION_ID"
gh secret set TF_VAR_STREAMX_OPERATOR_IMAGE_PULL_SECRET_REGISTRY_PASSWORD -b "$TF_VAR_streamx_operator_image_pull_secret_registry_password"

if [ -f "$SETUP_REPO_SCRIPT_DIR/../../gateway/tls/rest-ingestion.crt.yaml" ]; then
    gh secret set SX_SEC_AUTH_PRIVATE_KEY --body "$(cat "$SETUP_REPO_SCRIPT_DIR/../../gateway/tls/sx-sec-auth-private-key.yaml")"
fi

if [ -f "$SETUP_REPO_SCRIPT_DIR/../../gateway/tls/rest-ingestion.crt.yaml" ]; then
    gh secret set BLUEPRINT_WEB_CERT --body "$(cat "$SETUP_REPO_SCRIPT_DIR/../../gateway/tls/blueprint-web.crt.yaml")"
fi

if [ -f "$SETUP_REPO_SCRIPT_DIR/../../gateway/tls/rest-ingestion.crt.yaml" ]; then
    gh secret set BLUEPRINT_SEARCH_CERT --body "$(cat "$SETUP_REPO_SCRIPT_DIR/../../gateway/tls/blueprint-search.crt.yaml")"
fi

if [ -f "$SETUP_REPO_SCRIPT_DIR/../../gateway/tls/rest-ingestion.crt.yaml" ]; then
    gh secret set REST_INGESTION_CERT --body "$(cat "$SETUP_REPO_SCRIPT_DIR/../../gateway/tls/rest-ingestion.crt.yaml")"
fi