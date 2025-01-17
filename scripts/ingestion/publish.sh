#!/bin/bash

# Set default INGESTION_URL if not provided
if [ -z "$STREAMX_INGESTION_URL" ]; then
    STREAMX_INGESTION_URL="http://localhost:8080"
    echo "STREAMX_INGESTION_URL not provided: Using default URL - $STREAMX_INGESTION_URL"
fi

# Check for required parameters
if [ -z "$1" ]; then
    echo "You must provide an ingestion channel"
    exit 1
fi

if [ -z "$2" ]; then
    echo "You must provide an ingestion payload"
    exit 1
fi

# Prepare headers
HEADERS=("-H" "Content-Type: application/json")
if [ -n "$STREAMX_INGESTION_AUTH_TOKEN" ]; then
    HEADERS+=("-H" "Authorization: Bearer ${STREAMX_INGESTION_AUTH_TOKEN}")
else
    echo "STREAMX_INGESTION_AUTH_TOKEN not provided: Authorization header will be omitted"
fi

if [ -f "$2" ]; then
  if [ -z "$3" ]; then
      echo "You must provide a key"
      exit 1
  fi
  streamx publish -b "content.bytes=file://$2" "$1" "$3"
else
  curl -w " - status: %{response_code} \n" -X POST "${STREAMX_INGESTION_URL}/ingestion/v1/channels/$1/messages" \
       "${HEADERS[@]}" \
       -d "$2"
fi


