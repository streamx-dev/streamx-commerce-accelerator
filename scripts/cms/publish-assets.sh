#!/bin/bash

echo "Ingesting assets..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

INPUT_DIR="$SCRIPT_DIR/../../assets"

for asset in $(find "$INPUT_DIR" -type f ); do
    if [[ "$(basename "$asset")" =~ ^\..* ]]; then
        continue
    fi

    if [ ! -e "$asset" ]; then
        exit 0
    fi
    RELATIVE_PATH=$(echo "$asset" | sed "s|^$INPUT_DIR/||")

    echo "$RELATIVE_PATH"
    sh "$SCRIPT_DIR/../ingestion/publish.sh" assets "$asset" "assets/$RELATIVE_PATH"  > /dev/null 2>&1
done

echo "Web resources successfully ingested"
