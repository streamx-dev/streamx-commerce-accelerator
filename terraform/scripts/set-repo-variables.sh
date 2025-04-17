#!/bin/bash
set -e

gh variable set TF_VAR_CERT_MANAGER_LETS_ENCRYPT_ISSUER_ACME_EMAIL -b "$TF_VAR_cert_manager_lets_encrypt_issuer_acme_email"
gh variable set TF_VAR_STREAMX_OPERATOR_IMAGE_PULL_SECRET_REGISTRY_EMAIL -b "$TF_VAR_streamx_operator_image_pull_secret_registry_email"
gh variable set TF_VAR_RESOURCE_GROUP_NAME -b "$TF_VAR_resource_group_name"
gh variable set TF_VAR_LOCATION -b "$TF_VAR_location"
gh variable set TF_VAR_MONITORING_STORAGE_ACCOUNT_NAME -b "$TF_VAR_monitoring_storage_account_name"
gh variable set TF_VAR_MONITORING_STORAGE_CONTAINER_NAME -b "$TF_VAR_monitoring_storage_container_name"

if [[ -n "$TF_VAR_user_identity_id" ]]; then
gh variable set TF_VAR_USER_IDENTITY_ID -b "$TF_VAR_user_identity_id"
fi
if [[ -n "$TF_VAR_public_ip_address" ]]; then
gh variable set TF_VAR_PUBLIC_IP_ADDRESS -b "$TF_VAR_public_ip_address"
fi
if [[ -n "$TF_VAR_public_ip_id" ]]; then
gh variable set TF_VAR_PUBLIC_IP_ID -b "$TF_VAR_public_ip_id"
fi
if [[ -n "$TF_VAR_cert_manager_lets_encrypt_issuer_prod_letsencrypt_server" ]]; then
gh variable set TF_VAR_CERT_MANAGER_LETS_ENCRYPT_ISSUER_PROD_LETSENCRYPT_SERVER -b "$TF_VAR_cert_manager_lets_encrypt_issuer_prod_letsencrypt_server"
fi
if [[ -n "$TF_VAR_monitoring_grafana_host" ]]; then
gh variable set TF_VAR_MONITORING_GRAFANA_HOST -b "$TF_VAR_monitoring_grafana_host"
fi
if [[ -n "$TF_VAR_streamx_operator_use_pulsar_proxy" ]]; then
gh variable set TF_VAR_STREAMX_OPERATOR_USE_PULSAR_PROXY -b "$TF_VAR_streamx_operator_use_pulsar_proxy"
fi




