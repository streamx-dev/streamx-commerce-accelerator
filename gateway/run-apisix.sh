#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/ingestion/read-env.sh"

docker compose -p docker-apisix down
docker-compose -p docker-apisix -f docker-compose-arm64.yml up -d

docker network connect docker-apisix_apisix blueprint-web.webserver  >/dev/null 2>&1
docker network connect docker-apisix_apisix blueprint-search  >/dev/null 2>&1
docker network connect docker-apisix_apisix rest-ingestion  >/dev/null 2>&1

docker rm -f apisix-dashboard >/dev/null 2>&1

docker run -d --name apisix-dashboard \
           -p 9000:9000        \
            --network docker-apisix_apisix \
           -v `pwd`/dashboard_conf.yaml:/usr/local/apisix-dashboard/conf/conf.yaml \
           apache/apisix-dashboard


#Sync routes
YAML_FILE='./routes.yaml'
json_content=$(envsubst < "$YAML_FILE" | yq eval -o=json)

echo "$json_content" | jq -c '.routes[]' | while read -r route; do

  curl -i "http://127.0.0.1:9180/apisix/admin/routes" \
    -X PUT \
    -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
    -d "$route" \
    -H "Content-Type: application/json"  >/dev/null 2>&1
done
