# Cloud kubeconfig path. If StreamX Platform Terraform script was applied on the same host as this script is launched it can be taken from its 'kubeconfig_path' output.
export KUBECONFIG=
# Cloud Load Balancer IP. Should be taken from StreamX Platform Terraform script 'loadbalancer_ip' output
export STREAMX_INGRESS_IP=
export STREAMX_INGESTION_URL="http://ingestion.${STREAMX_INGRESS_IP}.nip.io"
export STREAMX_INTERNAL_INGESTION_URL="$STREAMX_INGESTION_URL"