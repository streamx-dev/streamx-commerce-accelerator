#!/bin/bash
set -e

SETUP_REPO_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

gh secret set ARM_ACCESS_KEY -b "$ARM_ACCESS_KEY"
gh secret set ARM_CLIENT_ID -b "$ARM_CLIENT_ID"
gh secret set ARM_CLIENT_SECRET -b "$ARM_CLIENT_SECRET"
gh secret set ARM_TENANT_ID -b "$ARM_TENANT_ID"
gh secret set ARM_SUBSCRIPTION_ID -b "$ARM_SUBSCRIPTION_ID"
gh secret set TF_VAR_STREAMX_OPERATOR_IMAGE_PULL_SECRET_REGISTRY_PASSWORD -b "$TF_VAR_streamx_operator_image_pull_secret_registry_password"
gh secret set TF_VAR_MONITORING_STORAGE_ACCESS_KEY -b "$TF_VAR_monitoring_storage_access_key"

if [ -f "$SETUP_REPO_SCRIPT_DIR/../../mesh/auth/sx-ing-sources-auth-private-key" ]; then
    gh secret set SX_SEC_AUTH_PRIVATE_KEY --body "$(cat "$SETUP_REPO_SCRIPT_DIR/../../mesh/auth/sx-ing-sources-auth-private-key.yaml")"
fi

if [ -f "$SETUP_REPO_SCRIPT_DIR/../../gateway/tls/blueprint-web.crt.yaml" ]; then
    gh secret set BLUEPRINT_WEB_TLS_CERT --body "$(cat "$SETUP_REPO_SCRIPT_DIR/../../gateway/tls/blueprint-web.crt.yaml")"
fi

if [ -f "$SETUP_REPO_SCRIPT_DIR/../../gateway/tls/rest-ingestion.crt.yaml" ]; then
    gh secret set REST_INGESTION_TLS_CERT --body "$(cat "$SETUP_REPO_SCRIPT_DIR/../../gateway/tls/rest-ingestion.crt.yaml")"
fi

if [ -f "$SETUP_REPO_SCRIPT_DIR/../../gateway/tls/grafana.crt.yaml" ]; then
    gh secret set GRAFANA_TLS_CERT --body "$(cat "$SETUP_REPO_SCRIPT_DIR/../../gateway/tls/grafana.crt.yaml")"
fi

if [[ -n "$TF_VAR_monitoring_grafana_admin_password" ]]; then
    gh secret set TF_VAR_MONITORING_GRAFANA_ADMIN_PASSWORD -b "$TF_VAR_monitoring_grafana_admin_password"
fi

if [[ -n "$STREAMX_GH_AUTH_TOKEN" ]]; then
    gh secret set STREAMX_GH_AUTH_TOKEN -b "$STREAMX_GH_AUTH_TOKEN"
fi