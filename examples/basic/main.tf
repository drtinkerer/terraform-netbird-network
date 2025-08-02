terraform {
  required_version = ">= 1.0"

  required_providers {
    netbird = {
      source  = "netbirdio/netbird"
      version = "~> 0.0.3"
    }
  }
}

provider "netbird" {
  token          = var.netbird_token
  management_url = var.netbird_management_url
}

module "simple_network" {
  source = "../../"

  network_name        = "simple-network"
  network_description = "A simple NetBird network"

  network_resources = {
    "local-network" = {
      description = "Local home network"
      address     = "192.168.1.0/24"
      enabled     = true
    }
  }

  # Use defaults for other configurations
  # - create_setup_key = false (default)
  # - create_default_policy = false (default)
  # - routing_peer_group_id = null (no routing)
}