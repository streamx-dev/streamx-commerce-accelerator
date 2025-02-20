#!/bin/bash
ENV_FILE=${1}

while IFS='=' read -r key value; do
  [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
  export "$key"="$value"
done < "$ENV_FILE"