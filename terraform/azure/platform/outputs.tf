output "kubeconfig_path" {
  description = "K8s cluster kubeconfig file path"
  value       = module.azure_platform.kubeconfig_path
}

output "kubeconfig_raw" {
  description = "K8s cluster kubeconfig file content"
  value       = module.azure_platform.kubeconfig_raw
  sensitive   = true
}

output "kubeconfig" {
  description = "K8s cluster kubeconfig"
  value       = module.azure_platform.kubeconfig
  sensitive   = true
}

output "loadbalancer_ip" {
  description = "K8s cluster Load Balancer IP"
  value       = module.streamx.loadbalancer_ip
}