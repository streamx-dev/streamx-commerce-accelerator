#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/cms/publish-rendering-engine-configs.sh"
"$SCRIPT_DIR/cms/publish-pages.sh"
"$SCRIPT_DIR/cms/publish-layouts.sh"
"$SCRIPT_DIR/cms/publish-assets.sh"
"$SCRIPT_DIR/cms/publish-templates.sh"
"$SCRIPT_DIR/cms/publish-web-resources.sh"

"$SCRIPT_DIR/pim/publish-categories.sh"
"$SCRIPT_DIR/pim/publish-products.sh"