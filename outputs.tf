output "network_id" {
  description = "ID of the created network"
  value       = netbird_network.this.id
}

output "network_name" {
  description = "Name of the created network"
  value       = netbird_network.this.name
}

output "default_resource_group_id" {
  description = "ID of the created group"
  value       = netbird_group.this.id
}

output "default_resource_group_name" {
  description = "Name of the created group"
  value       = netbird_group.this.name
}

output "network_resources" {
  description = "Map of network resource IDs keyed by resource name"
  value = {
    for key, resource in netbird_network_resource.this : key => resource.id
  }
}

output "network_resources_details" {
  description = "Map of network resources with full details, keyed by resource name"
  value = {
    for key, resource in netbird_network_resource.this : key => {
      id          = resource.id
      name        = resource.name
      address     = resource.address
      description = resource.description
      enabled     = resource.enabled
    }
  }
}

output "router_id" {
  description = "ID of the network router"
  value       = netbird_network_router.this.id
}

output "policy_id" {
  description = "ID of the default access policy (if created)"
  value       = var.create_default_policy && length(var.allowed_source_groups) > 0 ? netbird_policy.this[0].id : null
}

output "setup_key_id" {
  description = "ID of the setup key (if created)"
  value       = var.create_setup_key ? netbird_setup_key.this[0].id : null
}

output "setup_key" {
  description = "The actual setup key for device enrollment (if created)"
  value       = var.create_setup_key ? netbird_setup_key.this[0].key : null
  sensitive   = true
}
