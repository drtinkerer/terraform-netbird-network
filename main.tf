resource "netbird_network" "this" {
  name        = var.network_name
  description = var.network_description
}

resource "netbird_group" "this" {
  name = "resources-${var.network_name}"
}

resource "netbird_network_resource" "this" {
  for_each = var.network_resources

  network_id  = netbird_network.this.id
  name        = each.key
  description = each.value.description
  address     = each.value.address
  groups      = length(each.value.additional_groups) > 0 ? concat(each.value.additional_groups, [netbird_group.this.id]) : [netbird_group.this.id]
  enabled     = each.value.enabled
}

resource "netbird_network_router" "this" {
  count = var.routing_peer_group_id != null ? 1 : 0

  network_id  = netbird_network.this.id
  peer_groups = [var.routing_peer_group_id]
  metric      = var.router_config.metric
  enabled     = var.router_config.enabled
  masquerade  = var.router_config.masquerade
}

resource "netbird_policy" "this" {
  count = var.create_default_policy && length(var.allowed_source_groups) > 0 ? 1 : 0

  name        = var.policy_config.name != null ? var.policy_config.name : "Allow access to ${var.network_name}"
  description = var.policy_config.description != null ? var.policy_config.description : "Allow specified groups to access ${var.network_name} network"
  enabled     = var.policy_config.enabled

  rule {
    name          = var.policy_config.rule_name != null ? var.policy_config.rule_name : "Allow access to ${var.network_name}"
    action        = var.policy_config.action
    bidirectional = var.policy_config.bidirectional
    protocol      = var.policy_config.protocol
    ports         = length(var.policy_config.ports) > 0 ? var.policy_config.ports : null
    sources       = var.allowed_source_groups
    destinations  = [netbird_group.this.id]
  }
}

resource "netbird_setup_key" "this" {
  count = var.create_setup_key ? 1 : 0

  name                   = var.setup_key_config.name != null ? var.setup_key_config.name : "${var.network_name}-setup-key"
  type                   = var.setup_key_config.type
  expiry_seconds         = var.setup_key_config.expiry_seconds
  usage_limit            = var.setup_key_config.usage_limit
  auto_groups            = [var.routing_peer_group_id]
  ephemeral              = var.setup_key_config.ephemeral
  revoked                = false
  allow_extra_dns_labels = var.setup_key_config.allow_extra_dns_labels
}
