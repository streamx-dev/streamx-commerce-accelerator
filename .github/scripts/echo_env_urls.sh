#!/bin/bash

if [ -z "$QUARKUS_PROFILE" ]; then
  echo "QUARKUS_PROFILE env variable is required." >&2
  exit 1;
else
  quarkus_profile_prefix="_${QUARKUS_PROFILE}_"
fi

web_host="${quarkus_profile_prefix}WEB_HOST"
if [ -z "${!web_host}" ]; then
  echo "$web_host env variable is required." >&2
  exit 1;
fi

ingestion_host="${quarkus_profile_prefix}STREAMX_INGESTION_HOST"
if [ -z "${!ingestion_host}" ]; then
  echo "$ingestion_host env variable is required." >&2
  exit 1;
fi

web_url="https://${!web_host}"
ingestion_url="http://${!ingestion_host}"

echo "${quarkus_profile_prefix}STREAMX_INGESTION_URL=$ingestion_url"
echo "${quarkus_profile_prefix}STREAMX_INTERNAL_INGESTION_URL=$ingestion_url"
echo "${quarkus_profile_prefix}WEB_URL=$web_url"
