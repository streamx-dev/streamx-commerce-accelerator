#!/bin/bash

# Set default INGESTION_URL if not provided
if [ -z "$INGESTION_URL" ]; then
    INGESTION_URL="http://localhost:8080"
    echo "INGESTION_URL not provided: Using default URL - $INGESTION_URL"
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
if [ -n "$TOKEN" ]; then
    HEADERS+=("-H" "Authorization: Bearer ${TOKEN}")
else
    echo "TOKEN not provided: Authorization header will be omitted"
fi

# Send the request
curl -w " - status: %{response_code} \n" -X POST "${INGESTION_URL}/ingestion/v1/channels/$1/messages" \
     "${HEADERS[@]}" \
     -d "{
                \"key\" : \"$2\",
                \"action\" : \"unpublish\",
                \"eventTime\" : null,
                \"properties\" : {},
                \"payload\" : null
          }"
