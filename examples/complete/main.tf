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

  network_name        = "homelab"
  network_description = "Home laboratory network with full feature set"

  network_resources = {
    "home-lan" = {
      description = "Home local network"
      address     = "192.168.1.0/24"
      enabled     = true
    }
    "iot-network" = {
      description = "IoT devices network"
      address     = "192.168.10.0/24"
      enabled     = true
    }
    "guest-network" = {
      description = "Guest WiFi network"
      address     = "192.168.20.0/24"
      enabled     = true
    }
    "internal-services" = {
      description = "Internal services and APIs"
      address     = "10.0.0.0/16"
      enabled     = true
    }
    "home-assistant" = {
      description = "Home Assistant instance"
      address     = "homeassistant.local"
      enabled     = true
    }
    "nas-storage" = {
      description = "Network attached storage"
      address     = "nas.home.local"
      enabled     = true
    }
    "plex-server" = {
      description = "Plex media streaming server"
      address     = "plex.home.local"
      enabled     = true
    }
  }

  # Setup key configuration
  create_setup_key = true
  setup_key_config = {
    name                   = "homelab-router-key"
    type                   = "reusable"
    expiry_seconds         = 604800 # 7 days
    usage_limit            = 5
    ephemeral              = false
    allow_extra_dns_labels = true
  }

  # Router configuration (will default to the group created by this module)
  # routing_peer_group_id = "d26p92daofms73c1pgu0"  # Uncomment to override with custom group
  router_config = {
    metric     = 100
    masquerade = true
    enabled    = true
  }

  # Access policy configuration
  create_default_policy = true # No policy since no source groups specified
  policy_config = {
    name          = "homelab-policy"
    description   = "Allow access to Homelab"
    rule_name     = "Allow access to Homelab"
    protocol      = "all"
    action        = "accept"
    bidirectional = false
    ports         = []
  }
  allowed_source_groups = ["d26p92daofms73c1pgu0"]

}
