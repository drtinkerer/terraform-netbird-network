resource "netbird_network" "this" {
  name        = var.network_name
  description = var.network_description
}

resource "netbird_group" "this" {
  name = var.group_name
}

resource "netbird_network_resource" "this" {
  for_each = { for idx, resource in var.network_resources : idx => resource }

  network_id  = netbird_network.this.id
  name        = each.value.name
  description = each.value.description
  address     = each.value.address
  groups      = [netbird_group.this.id]
  enabled     = each.value.enabled
}

resource "netbird_setup_key" "this" {
  name                     = var.setup_key_name
  type                     = var.setup_key_config.type
  expiry_seconds           = var.setup_key_config.expiry_seconds
  usage_limit              = var.setup_key_config.usage_limit
  auto_groups              = [netbird_group.this.id]
  ephemeral                = var.setup_key_config.ephemeral
  revoked                  = false
  allow_extra_dns_labels   = var.setup_key_config.allow_extra_dns_labels
}

resource "netbird_network_router" "this" {
  count = var.enable_routing ? 1 : 0

  network_id   = netbird_network.this.id
  peer_groups  = [netbird_group.this.id]
  metric       = var.router_config.metric
  enabled      = true
  masquerade   = var.router_config.masquerade
}

data "netbird_group" "allowed_sources" {
  for_each = var.create_access_policy ? toset(var.allowed_source_groups) : []
  name     = each.key
}

resource "netbird_policy" "group_access" {
  count = var.create_access_policy ? 1 : 0

  name        = "Access to ${var.group_name}"
  description = "Allow specified groups to access ${var.group_name}"
  enabled     = true

  rule {
    name         = "Allow access to ${var.group_name}"
    action       = "accept"
    bidirectional = true
    protocol     = "all"
    sources      = [for group in data.netbird_group.allowed_sources : group.id]
    destinations = [netbird_group.this.id]
  }
}