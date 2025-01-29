#!/bin/sh

# Variables
INGRESS_NAME=$1
NAMESPACE=${2:-default}
TIMEOUT=${3:-300} # Default timeout is 300 seconds (5 minutes)
INTERVAL=5        # Time between checks in seconds

# Function to check ingress readiness
check_ingress_ready() {
  kubectl get ingress "$INGRESS_NAME" -n "$NAMESPACE" -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null
}

# Start the timer
START_TIME=$(date +%s)

echo "Checking if ingress $INGRESS_NAME in namespace $NAMESPACE is ready..."

while true; do
  # Check ingress status
  INGRESS_IP=$(check_ingress_ready)

  # If IP is assigned, ingress is ready
  if [ -n "$INGRESS_IP" ]; then
    echo "Ingress $INGRESS_NAME is ready. Load balancer IP: $INGRESS_IP"
    exit 0
  fi

  # Check for timeout
  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

  if [ "$ELAPSED_TIME" -ge "$TIMEOUT" ]; then
    echo "Timeout reached. Ingress $INGRESS_NAME is not ready." >&2
    exit 1
  fi

  # Wait before the next check
  sleep "$INTERVAL"
done
