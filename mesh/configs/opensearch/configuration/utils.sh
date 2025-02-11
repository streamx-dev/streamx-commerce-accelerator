#!/bin/bash

format_search_template() {
    SCRIPT_FILE="$1.txt"
    if [ ! -f ./$SCRIPT_FILE ]; then
        echo "ERROR Script $SCRIPT_FILE NOT found."
        unset SCRIPT_FILE
        return 0
    fi

    echo "INFO Reading script $SCRIPT_FILE"
    SCRIPT=$(head -2 $SCRIPT_FILE)
    SCRIPT+=$'\n\n'
    SCRIPT+=$(awk 'NR>3' $SCRIPT_FILE  | tr -s '\n' ' ')
    echo "--------------------------"
    echo "$SCRIPT"
    echo "--------------------------"

    OUTPUT_FILE="../../service-init/$1.http"

    echo "$SCRIPT" > "$OUTPUT_FILE"

    if [ ! -f $OUTPUT_FILE ]; then
      echo "ERROR Output file $OUTPUT_FILE NOT found."
      unset SCRIPT_FILE
      unset OUTPUT_FILE
      return 0
    fi

    return 0
}
