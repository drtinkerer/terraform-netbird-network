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

module "manual_network" {
  source = "../../"

  network_name        = "manual-network"
  network_description = "Network for manual device assignment (no setup key)"

  network_resources = {
    "production-services" = {
      description = "Production environment services"
      address     = "10.0.1.0/24"
      enabled     = true
    }
    "database-cluster" = {
      description = "Database servers"
      address     = "10.0.2.0/24"
      enabled     = true
    }
  }

  # No setup key creation (default: false)
  # No routing configuration (routing_peer_group_id = null)
  # No access policy (create_default_policy = false)

  # This creates only the network and resource group
  # Devices must be manually assigned to the created group
}