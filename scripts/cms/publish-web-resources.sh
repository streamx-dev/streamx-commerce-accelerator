#!/bin/bash

echo "Ingesting web-resources..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_DIR="$SCRIPT_DIR/../../web-resources"

for webResource in $(find "$INPUT_DIR" -type f ); do
    if [[ "$(basename "$webResource")" =~ ^\..* ]]; then
        continue
    fi

    if [ ! -e "$webResource" ]; then
        exit 0
    fi
    RELATIVE_PATH=$(echo "$webResource" | sed "s|^$INPUT_DIR/||")

    echo "$RELATIVE_PATH"
    sh "$SCRIPT_DIR/../ingestion/publish.sh" web-resources "$webResource" "web-resources/$RELATIVE_PATH"  > /dev/null 2>&1
done

echo "Web resources successfully ingested"
