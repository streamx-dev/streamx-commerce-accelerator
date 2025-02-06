#!/bin/bash
set -e

gh variable set TF_VAR_CERT_MANAGER_LETS_ENCRYPT_ISSUER_ACME_EMAIL -b "$TF_VAR_cert_manager_lets_encrypt_issuer_acme_email"
gh variable set TF_VAR_STREAMX_OPERATOR_IMAGE_PULL_SECRET_REGISTRY_EMAIL -b "$TF_VAR_streamx_operator_image_pull_secret_registry_email"
gh variable set TF_VAR_RESOURCE_GROUP_NAME -b "$TF_VAR_resource_group_name"
gh variable set TF_VAR_LOCATION -b "$TF_VAR_location"
gh variable set INGESTION_HOST -b "$INGESTION_HOST"
gh variable set WEB_HOST -b "$WEB_HOST"

