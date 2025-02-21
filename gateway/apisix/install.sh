helm upgrade --install apisix apisix/apisix \
  --create-namespace \
  --namespace ingress-apisix \
  -f values.yaml
kubectl patch ingressclass apisix -p '{"metadata": {"annotations": {"ingressclass.kubernetes.io/is-default-class": "true"}}}'
