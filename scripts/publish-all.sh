#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR"/ingestion/cert/generate_certs_hashed_symlinks.sh

"$SCRIPT_DIR/ingestion/cms/publish-rendering-engine-configs.sh"
"$SCRIPT_DIR/ingestion/cms/publish-pages.sh"
"$SCRIPT_DIR/ingestion/cms/publish-assets.sh"
"$SCRIPT_DIR/ingestion/cms/publish-templates.sh"
"$SCRIPT_DIR/ingestion/cms/publish-web-resources.sh"

"$SCRIPT_DIR/ingestion/pim/publish-categories.sh"
"$SCRIPT_DIR/ingestion/pim/publish-products.sh"

"$SCRIPT_DIR/info/web-url.sh"