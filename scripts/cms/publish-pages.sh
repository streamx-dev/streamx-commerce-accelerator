pdpRenderer='{
  "key" : "pdp-renderer",
  "action" : "publish",
  "eventTime" : null,
  "properties" : { },
  "payload" : {
    "dev.streamx.blueprints.data.Renderer" : {
      "template": {
        "bytes": "{{name}} - {{slug}}"
      }
    }
  }
}'

categoryRenderer='{
  "key" : "category-renderer",
  "action" : "publish",
  "eventTime" : null,
  "properties" : { },
  "payload" : {
    "dev.streamx.blueprints.data.Renderer" : {
      "template": {
        "bytes": "{{name}} - {{slug}}"
      }
    }
  }
}'

echo "Ingesting pages..."
sh ingestion/publish.sh renderers "$pdpRenderer" > /dev/null 2>&1
sh ingestion/publish.sh renderers "$categoryRenderer" > /dev/null 2>&1
echo "Pages successfully ingested"