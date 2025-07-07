output "network_id" {
  description = "ID of the created network"
  value       = module.manual_network.network_id
}

output "group_id" {
  description = "ID of the created group"
  value       = module.manual_network.group_id
}

output "setup_key" {
  description = "The setup key for devices (null when disabled)"
  value       = module.manual_network.setup_key
  sensitive   = true
}

output "network_resources" {
  description = "Map of network resources created"
  value       = module.manual_network.network_resources
}