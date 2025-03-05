output "kubeconfig_path" {
  description = "K8s cluster kubeconfig file path"
  value       = module.cluster.kubeconfig_path
}

output "kubeconfig" {
  description = "K8s cluster kubeconfig"
  value       = module.cluster.kubeconfig
  sensitive   = true
}

output "loadbalancer_ip" {
  description = "K8s cluster Load Balancer IP"
  value       = module.streamx.loadbalancer_ip
}