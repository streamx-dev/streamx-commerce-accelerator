#!/bin/bash

if [ -z "$QUARKUS_PROFILE" ]; then
  echo "QUARKUS_PROFILE env variable is required."
  exit 1;
else
  QUARKUS_PROFILE_PREFIX="_${QUARKUS_PROFILE}_"
fi

cms_token=$(kubectl get secrets sx-sec-auth-jwt-cms -o jsonpath  -o jsonpath="{.data.jwt}" | base64 --decode)
pim_token=$(kubectl get secrets sx-sec-auth-jwt-pim -o jsonpath  -o jsonpath="{.data.jwt}" | base64 --decode)

echo "${QUARKUS_PROFILE_PREFIX}STREAMX_TOKEN_INGESTION_AUTH_TOKEN_CMS=$cms_token"
echo "${QUARKUS_PROFILE_PREFIX}STREAMX_TOKEN_INGESTION_AUTH_TOKEN_PIM=$pim_token"
