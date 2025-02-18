#!/bin/bash
set -e

gh secret set ARM_ACCESS_KEY -b "$ARM_ACCESS_KEY"
gh secret set ARM_CLIENT_ID -b "$ARM_CLIENT_ID"
gh secret set ARM_CLIENT_SECRET -b "$ARM_CLIENT_SECRET"
gh secret set ARM_TENANT_ID -b "$ARM_TENANT_ID"
gh secret set ARM_SUBSCRIPTION_ID -b "$ARM_SUBSCRIPTION_ID"
gh secret set TF_VAR_STREAMX_OPERATOR_IMAGE_PULL_SECRET_REGISTRY_PASSWORD -b "$TF_VAR_streamx_operator_image_pull_secret_registry_password"