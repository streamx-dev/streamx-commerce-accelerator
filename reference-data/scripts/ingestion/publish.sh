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

if [ -z "$2" ] && [ ! -p /dev/stdin ]; then
    echo "You must provide an ingestion payload"
    exit 1
fi

# Prepare headers
HEADERS=("-H" "Content-Type: application/json")
if [ -n "$STREAMX_INGESTION_AUTH_TOKEN" ]; then
    HEADERS+=("-H" "Authorization: Bearer ${STREAMX_INGESTION_AUTH_TOKEN}")
fi

if [ -f "$2" ]; then
  if [ -z "$3" ]; then
      echo "You must provide a key"
      exit 1
  fi

  result=$(streamx publish -b "content.bytes=file://$2" "$1" "$3")

  if [[ $result != Registered* ]]; then
      echo "$result"
      exit 1
  fi
else
  if [ -z "$2" ]; then
    data=$(</dev/stdin)
  else
    data=$2
  fi
  response=$(echo "$data" | curl -s -w " - status: %{response_code}" -X POST "${STREAMX_INGESTION_URL}/ingestion/v1/channels/$1/messages" \
         "${HEADERS[@]}" \
         --data @-)

  status=$(echo "$response" | awk -F " - status: " '{print $2}' | grep -v '^$')
  body=$(echo "$response" | sed -E 's/ - status: [0-9]+$//')

  if [[ $status -ne 202 ]]; then
      echo "Error: Received HTTP status $status"
      echo "Response body: $body"
      exit 1
  fi


fi
