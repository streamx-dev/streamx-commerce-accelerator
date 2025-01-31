#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

streamx_ingress_ip="$1"

web_host_template='puresight.{STREAMX_INGRESS_IP}.nip.io'
ingestion_host_template='ingestion.{STREAMX_INGRESS_IP}.nip.io'
web_host_template="${2:-${web_host_template}}"
ingestion_host_template="${3:-${ingestion_host_template}}"

web_host=$($SCRIPT_DIR/replace_ingress_ip.sh "$streamx_ingress_ip" "$web_host_template")
ingestion_host=$($SCRIPT_DIR/replace_ingress_ip.sh "$streamx_ingress_ip" "$ingestion_host_template")

if [ -z "$QUARKUS_PROFILE" ]; then
  echo "QUARKUS_PROFILE env variable is required." >&2
  exit 1;
else
  quarkus_profile_prefix="_${QUARKUS_PROFILE}_"
fi

echo "${quarkus_profile_prefix}STREAMX_INGESTION_HOST=$ingestion_host"
echo "${quarkus_profile_prefix}WEB_HOST=$web_host"
