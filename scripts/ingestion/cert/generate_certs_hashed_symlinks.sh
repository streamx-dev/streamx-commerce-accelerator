#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CERT_DIR="${1:-$SCRIPT_DIR}"

for cert_file in "$CERT_DIR"/*.{crt,cer,pem}; do
    [ -e "$cert_file" ] || continue  # Skip if no matching files
    hash=$(openssl x509 -hash -noout -in "$cert_file")
    link_path="$CERT_DIR/$hash.0"

    # Check if the symlink already exists before creating it
    if [ ! -e "$link_path" ]; then
        ln -s "$cert_file" "$link_path"
    fi
done