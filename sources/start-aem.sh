#!/bin/bash

thisScriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
dockerComposeFile="$thisScriptDir/docker-compose.yml"

if [ $# -lt 1 ]; then
  echo "ERROR: Missing required argument STREAMX_CLIENT_URL."
  exit 1
fi

STREAMX_CLIENT_URL="$1"
STREAMX_CLIENT_AUTH_TOKEN="$2"

if [ $# -lt 2 ]; then
  STREAMX_CLIENT_AUTH_TOKEN=""
fi

export STREAMX_CLIENT_URL="$1"
export STREAMX_CLIENT_AUTH_TOKEN="$2"

echo "Checking if 'aem-author-cloud:latest' Docker image is present..."
docker images | grep -q 'aem-author-cloud\s*latest'
if [ $? -ne 0 ]; then
  echo "The 'aem-author-cloud:latest' image was not found."
  echo "Please load it before running this script (see README for details)."
  exit 1
fi

echo "Attempting to purge old PureSight & WKND AEM Docker artifacts..."
docker container rm -f aem-author-cloud 2>/dev/null
docker volume rm -f aem-author-cloud-data 2>/dev/null
docker network rm aem-network 2>/dev/null

echo "Starting AEM container with:"
echo "  STREAMX_CLIENT_URL:        $STREAMX_CLIENT_URL"
echo "  STREAMX_CLIENT_AUTH_TOKEN: [HIDDEN]"

docker compose -f "$dockerComposeFile" up -d
