output "network_id" {
  description = "ID of the created network"
  value       = module.homelab_network.network_id
}

output "group_id" {
  description = "ID of the created group"
  value       = module.homelab_network.default_resource_group_id
}

output "setup_key" {
  description = "The setup key for devices"
  value       = module.homelab_network.setup_key
  sensitive   = true
}

output "network_resources" {
  description = "Map of network resources created"
  value       = module.homelab_network.network_resources
}

output "router_id" {
  description = "ID of the network router"
  value       = module.homelab_network.router_id
}

output "policy_id" {
  description = "ID of the access policy"
  value       = module.homelab_network.policy_id
}