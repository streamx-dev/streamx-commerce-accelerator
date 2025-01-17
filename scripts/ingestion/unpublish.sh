#!/bin/bash

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
    echo "You must provide the key to unpublish"
    exit 1
fi

# Prepare headers
HEADERS=("-H" "Content-Type: application/json")
if [ -n "$STREAMX_INGESTION_AUTH_TOKEN" ]; then
    HEADERS+=("-H" "Authorization: Bearer ${STREAMX_INGESTION_AUTH_TOKEN}")
else
    echo "STREAMX_INGESTION_AUTH_TOKEN not provided: Authorization header will be omitted"
fi

# Send the request
curl -w " - status: %{response_code} \n" -X POST "${STREAMX_INGESTION_URL}/ingestion/v1/channels/$1/messages" \
     "${HEADERS[@]}" \
     -d "{
                \"key\" : \"$2\",
                \"action\" : \"unpublish\",
                \"eventTime\" : null,
                \"properties\" : {},
                \"payload\" : null
          }"
