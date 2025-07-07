terraform {
  required_version = ">= 1.0"

  required_providers {
    netbird = {
      source  = "netbirdio/netbird"
      version = ">= 0.0.3"
    }
  }
}

provider "netbird" {
  token          = var.netbird_token
  management_url = var.netbird_management_url
}

module "manual_network" {
  source = "../../"

  network_name        = "Manual Network"
  network_description = "Network without automatic setup key"
  group_name          = "Manual-Assignment-Group"

  network_resources = [
    {
      name        = "Production Services"
      description = "Production environment services"
      address     = "10.0.1.0/24"
      enabled     = true
    },
    {
      name        = "Database Cluster"
      description = "Database servers"
      address     = "10.0.2.0/24"
      enabled     = true
    }
  ]

  create_setup_key     = false # No automatic setup key
  create_access_policy = true
  enable_routing       = true
}