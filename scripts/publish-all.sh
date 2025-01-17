#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sh "$SCRIPT_DIR/configs/publish-rendering-engine-configs.sh"
sh "$SCRIPT_DIR/cms/publish-pages.sh"
sh "$SCRIPT_DIR/cms/publish-assets.sh"
sh "$SCRIPT_DIR/cms/publish-templates.sh"
sh "$SCRIPT_DIR/cms/publish-web-resources.sh"
sh "$SCRIPT_DIR/pim/publish-categories.sh"
sh "$SCRIPT_DIR/configs/publish-rendering-engine-configs.sh"
sh "$SCRIPT_DIR/pim/publish-products.sh"