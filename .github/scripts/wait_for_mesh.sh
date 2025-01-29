#!/bin/sh

# Variables
NAMESPACE=${1:-default}    # Namespace, default is "default"
TIMEOUT=${2:-600}          # Timeout in seconds, default is 300 (5 minutes)
INTERVAL=5                 # Time between checks in seconds
CR_NAME="sx"               # The name of the custom resource
CR_KIND="ServiceMesh"
CONDITION_TYPE="Ready"
CONDITION_STATUS="True"

# Function to check the condition of the custom resource
check_condition() {
  READY_STATUS=$(kubectl get "$CR_KIND" "$CR_NAME" -n "$NAMESPACE" -o json | \
    jq -r ".status.conditions[] | select(.type == \"$CONDITION_TYPE\" and .status == \"$CONDITION_STATUS\")")

  if [ -n "$READY_STATUS" ]; then
    return 0
  else
    return 1
  fi
}

# Start the timer
START_TIME=$(date +%s)

echo "Waiting for condition $CONDITION_TYPE=$CONDITION_STATUS on $CR_KIND/$CR_NAME..."

while true; do

  if check_condition; then
    echo "$CR_KIND/$CR_NAME is ready!"
    exit 0
  fi

  # Check for timeout
  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

  if [ "$ELAPSED_TIME" -ge "$TIMEOUT" ]; then
    echo "Timeout reached. $CR_KIND/$CR_NAME is not ready." >&2
    exit 1
  fi

  # Wait before the next check
  sleep "$INTERVAL"
done
