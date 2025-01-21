#!/bin/bash
docker rm -f nginx-proxy >/dev/null 2>&1

echo "The following URLs are available:"
echo " - http://puresight.127.0.0.1.nip.io"
echo " - http://ingestion.127.0.0.1.nip.io"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
NGINX_CONF="${SCRIPT_DIR}/proxy.conf"
docker run -d --rm --name nginx-proxy -p 80:80 nginx:1.26.0
# We are not mounting, because it caused problems in WSL:
docker cp "${NGINX_CONF}" nginx-proxy:/etc/nginx/nginx.conf
docker exec nginx-proxy nginx -s reload
