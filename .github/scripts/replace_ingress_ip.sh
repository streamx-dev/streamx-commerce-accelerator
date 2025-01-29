ingress_ip="$1"
host_template="$2"
echo "${host_template//\{STREAMX_INGRESS_IP\}/$ingress_ip}"