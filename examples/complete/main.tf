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

module "homelab_network" {
  source = "../../"

  network_name        = "Homelab"
  network_description = "Home laboratory network"
  group_name          = "Homelab-Auto-Assigned"
  setup_key_name      = "Homelab Setup Key"

  network_resources = [
    {
      name        = "Home LAN"
      description = "Home local network"
      address     = "192.168.1.0/24"
      enabled     = true
    },
    {
      name        = "IoT Network"
      description = "IoT devices network"
      address     = "192.168.10.0/24"
      enabled     = true
    },
    {
      name        = "Guest Network"
      description = "Guest WiFi network"
      address     = "192.168.20.0/24"
      enabled     = true
    },
    {
      name        = "Internal Services"
      description = "Internal services and APIs"
      address     = "10.0.0.0/16"
      enabled     = true
    },
    {
      name        = "Home Assistant"
      description = "Home Assistant instance"
      address     = "homeassistant.local"
      enabled     = true
    },
    {
      name        = "NAS Storage"
      description = "Network attached storage"
      address     = "nas.home.local"
      enabled     = true
    },
    {
      name        = "Plex Media Server"
      description = "Plex media streaming server"
      address     = "plex.home.local"
      enabled     = true
    }
  ]

  setup_key_config = {
    type                   = "reusable"
    expiry_seconds         = 0
    usage_limit            = 0
    ephemeral              = false
    allow_extra_dns_labels = true
  }

  router_config = {
    metric     = 9999
    masquerade = true
  }

  allowed_source_groups = ["All"]
  create_setup_key      = true
  create_access_policy  = true
  enable_routing        = true
}