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

# Get existing groups for routing and access control
data "netbird_group" "routers" {
  name = "homelab-routers" # Assumes this group exists
}

data "netbird_group" "clients" {
  name = "homelab-clients" # Assumes this group exists  
}

data "netbird_group" "admins" {
  name = "admins" # Assumes this group exists
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
      description       = "Internal services and APIs"
      address           = "10.0.0.0/16"
      enabled           = true
      additional_groups = [data.netbird_group.admins.id] # Admins also get access
    }
    "home-assistant" = {
      description = "Home Assistant instance"
      address     = "homeassistant.local"
      enabled     = true
    }
    "nas-storage" = {
      description       = "Network attached storage"
      address           = "nas.home.local"
      enabled           = true
      additional_groups = [data.netbird_group.admins.id] # Admins also get access
    }
    "plex-server" = {
      description = "Plex media streaming server"
      address     = "plex.home.local"
      enabled     = true
    }
  }

  # Configure routing through dedicated router group
  routing_peer_group_id = data.netbird_group.routers.id

  router_config = {
    metric     = 100
    masquerade = true
    enabled    = true
  }

  # Create access policy for clients
  create_default_policy = true
  allowed_source_groups = [data.netbird_group.clients.id, data.netbird_group.admins.id]

  policy_config = {
    name          = "Homelab Network Access"
    description   = "Allow clients and admins to access homelab resources"
    protocol      = "tcp"
    ports         = ["80", "443", "8080", "8123", "32400"] # HTTP, HTTPS, Alt HTTP, Home Assistant, Plex
    bidirectional = false
    enabled       = true
  }

  # Create setup key for router enrollment
  create_setup_key = true
  setup_key_config = {
    name                   = "homelab-router-key"
    type                   = "reusable"
    expiry_seconds         = 604800 # 7 days
    usage_limit            = 5
    ephemeral              = false
    allow_extra_dns_labels = true
  }
}