terraform {
  required_providers {
    netbird = {
      source = "netbirdio/netbird"
    }
  }
}

provider "netbird" {
  token          = var.netbird_token
  management_url = var.netbird_management_url
}

module "simple_network" {
  source = "../../"

  network_name        = "Simple Network"
  network_description = "A simple NetBird network"
  group_name          = "Auto-Assigned-Group"
  setup_key_name      = "Simple Setup Key"

  network_resources = [
    {
      name        = "Local Network"
      description = "Local home network"
      address     = "192.168.1.0/24"
      enabled     = true
    }
  ]

  # Use defaults for other configurations
}