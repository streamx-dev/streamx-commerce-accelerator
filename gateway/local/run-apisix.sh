#!/bin/bash
cleanup() {
    echo "Stopping and removing containers..."
    docker compose -p docker-apisix down
    docker rm -f apisix-dashboard >/dev/null 2>&1
    exit 0
}

trap cleanup SIGINT SIGTERM

docker compose -p docker-apisix down

ARCH=$(uname -m)

if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    echo "Detected ARM64 architecture. Using docker-compose-arm64.yml"
    docker-compose -p docker-apisix -f docker-compose-arm64.yml up -d
else
    echo "Detected non-ARM64 architecture. Using docker-compose.yml"
    docker-compose -p docker-apisix -f docker-compose.yml up -d
fi

docker network connect docker-apisix_apisix blueprint-web.webserver  >/dev/null 2>&1
docker network connect docker-apisix_apisix blueprint-search  >/dev/null 2>&1
docker network connect docker-apisix_apisix rest-ingestion  >/dev/null 2>&1

DASHBOARD_ENABLED=false
for arg in "$@"; do
  if [ "$arg" == "dashboard-enabled=true" ]; then
    DASHBOARD_ENABLED=true
    break
  fi
done

docker rm -f apisix-dashboard >/dev/null 2>&1

if [ "$DASHBOARD_ENABLED" == "true" ]; then
  docker run -d --name apisix-dashboard \
             -p 9000:9000 \
             --network docker-apisix_apisix \
             -v "$(pwd)"/dashboard_conf.yaml:/usr/local/apisix-dashboard/conf/conf.yaml \
             apache/apisix-dashboard
fi

# Wait for APISIX
until [ "$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:9180/apisix/admin/routes")" == "401" ]; do
  sleep 1
done


# Sync routes
YAML_FILE='./routes.yaml'
json_content=$(envsubst < "$YAML_FILE" | yq eval -o=json)

echo "$json_content" | jq -c '.routes[]' | while read -r route; do
  curl -i "http://127.0.0.1:9180/apisix/admin/routes" \
    -X PUT \
    -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
    -d "$route" \
    -H "Content-Type: application/json" >/dev/null 2>&1
done


echo "Press CTRL+C stop and clean up."
while true; do sleep 1; done
