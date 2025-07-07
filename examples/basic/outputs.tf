output "setup_key" {
  description = "The setup key for devices"
  value       = module.simple_network.setup_key
  sensitive   = true
}

output "network_id" {
  description = "ID of the created network"
  value       = module.simple_network.network_id
}