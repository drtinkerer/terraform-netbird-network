output "network_id" {
  description = "ID of the created network"
  value       = netbird_network.this.id
}

output "network_name" {
  description = "Name of the created network"
  value       = netbird_network.this.name
}

output "group_id" {
  description = "ID of the created group"
  value       = netbird_group.this.id
}

output "group_name" {
  description = "Name of the created group"
  value       = netbird_group.this.name
}

output "setup_key_id" {
  description = "ID of the setup key (if created)"
  value       = var.create_setup_key ? netbird_setup_key.this[0].id : null
}

output "setup_key" {
  description = "The setup key for devices (if created)"
  value       = var.create_setup_key ? netbird_setup_key.this[0].key : null
  sensitive   = true
}

output "network_resources" {
  description = "Map of network resources created"
  value = {
    for idx, resource in netbird_network_resource.this : idx => {
      id          = resource.id
      name        = resource.name
      address     = resource.address
      description = resource.description
      enabled     = resource.enabled
    }
  }
}

output "router_id" {
  description = "ID of the network router (if enabled)"
  value       = var.enable_routing ? netbird_network_router.this[0].id : null
}

output "policy_id" {
  description = "ID of the access policy (if created)"
  value       = var.create_access_policy ? netbird_policy.group_access[0].id : null
}