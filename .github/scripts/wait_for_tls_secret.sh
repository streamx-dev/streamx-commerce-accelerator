#!/bin/bash

# Check if the necessary arguments are provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <ingress-name> [namespace] [timeout]"
    exit 1
fi

INGRESS_NAME=$1
NAMESPACE=${2:-default}
TIMEOUT=${3:-300} # Default timeout is 300 seconds (5 minutes)
INTERVAL=5        # Time between checks in seconds

# Function to check the status of the ingress
get_tls_secret_name() {
    kubectl get ingress "$INGRESS_NAME" -n "$NAMESPACE" -o=jsonpath='{.spec.tls[0].secretName}' 2>/dev/null
}

check_if_cert_ready() {
  kubectl get certificate "$SECRET_NAME" -n "$NAMESPACE" -o=jsonpath="{.status.conditions[?(@.type=='Ready')].status}" | grep -q "True"
}

# Start the timer
START_TIME=$(date +%s)

# Wait until Cert Manager generates the certificate (i.e., secret is created)
echo "Waiting for Cert Manager to generate certificate for ingress '$INGRESS_NAME' in namespace '$NAMESPACE'..."

while true; do
    SECRET_NAME=$(get_tls_secret_name)

    if [ -z "$SECRET_NAME" ]; then
        echo "TLS secret name for ingress '$INGRESS_NAME' has not been set."
        exit 1
    else
        if check_if_cert_ready; then
          echo "Cert is ready"
          exit 0
        else
          echo "Waiting... Certificate not yet issued."
          # Check for timeout
          CURRENT_TIME=$(date +%s)
          ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

          if [ "$ELAPSED_TIME" -ge "$TIMEOUT" ]; then
            echo "Timeout reached. Ingress $INGRESS_NAME is not ready." >&2
            exit 1
          fi

          # Wait before the next check
          sleep "$INTERVAL"
        fi
    fi
done
