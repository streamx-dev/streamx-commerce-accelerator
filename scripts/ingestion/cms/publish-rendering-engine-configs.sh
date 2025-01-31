#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ingestion/read-env.sh"
export STREAMX_INGESTION_AUTH_TOKEN="$STREAMX_TOKEN_INGESTION_AUTH_TOKEN_CMS"

pdpRenderingContext='{
  "key": "pdp-rendering-context",
  "action": "publish",
  "eventTime": null,
  "properties": { },
  "payload": {
    "dev.streamx.blueprints.data.RenderingContext": {
      "rendererKey": { "string": "templates/pdp.html" },
      "dataKeyMatchPattern": { "string": "product:.*" },
      "outputKeyTemplate": { "string": "/products/{{slug}}.html" },
      "outputType": { "dev.streamx.blueprints.data.RenderingContext.OutputType": "PAGE" }
    }
  }
}'

categoryRenderingContext='{
  "key": "category-rendering-context",
  "action": "publish",
  "eventTime": null,
  "properties": { },
  "payload": {
    "dev.streamx.blueprints.data.RenderingContext": {
      "rendererKey": { "string": "templates/pcp.html" },
      "dataKeyMatchPattern": { "string": "category:.*" },
      "outputKeyTemplate": { "string": "/categories/{{slug}}.html" },
      "outputType": { "dev.streamx.blueprints.data.RenderingContext.OutputType": "PAGE" }
    }
  }
}'

echo "Ingesting rendering engine configurations..."
"$SCRIPT_DIR/../publish.sh" rendering-contexts "$pdpRenderingContext"
"$SCRIPT_DIR/../publish.sh" rendering-contexts "$categoryRenderingContext"
echo "Rendering engine configs ingestion finished"