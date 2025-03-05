output "floatingip" {
  description = "Allocated floating IP for future usage"
  value       = module.tf_network.floatingip
}

output "nodes_subnet_id" {
  description = "Nodes subnet ID"
  value       = module.tf_network.nodes_subnet_id
}

output "network_id" {
  description = "Network id to attach cluster"
  value       = module.tf_network.network_id
}

