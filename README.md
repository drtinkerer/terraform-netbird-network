# Terraform NetBird Network Module

A Terraform module for creating and managing NetBird networks with automatic peer grouping, network resources, routing, and access policies.

## Features

- **Network Creation**: Create NetBird networks with custom descriptions
- **Auto-named Resource Groups**: Automatically create resource groups with naming convention `resources-{network_name}`
- **Network Resources**: Map-based resource management with support for CIDR blocks and domain names
- **Advanced Routing**: Automatic routing through the module's resource group, with optional override for external peer groups
- **Enhanced Access Policies**: Port-specific access control with configurable protocols and bidirectional rules
- **Flexible Setup Keys**: Optional setup key generation for device enrollment with external group assignment
- **Multi-Group Resources**: Support for assigning resources to additional groups beyond the default resource group

## Usage

### Basic Example

```hcl
module "homelab_network" {
  source = "cloudpoet-in/network/netbird"

  network_name        = "homelab"
  network_description = "Home laboratory network"

  network_resources = {
    "home-lan" = {
      description = "Home local network"
      address     = "192.168.1.0/24"
      enabled     = true
    }
    "nas-server" = {
      description = "Network attached storage"
      address     = "nas.home.local"
      enabled     = true
    }
  }

  # Router will automatically use the module's resource group
  router_config = {
    metric     = 100
    masquerade = true
    enabled    = true
  }
}
```

### With Routing and Access Policy

```hcl
# First, get an existing group ID for routing
data "netbird_group" "router_group" {
  name = "routers"
}

data "netbird_group" "clients" {
  name = "clients"
}

module "production_network" {
  source = "cloudpoet-in/network/netbird"

  network_name        = "production"
  network_description = "Production environment network"

  network_resources = {
    "api-gateway" = {
      description = "Production API gateway"
      address     = "api.company.com"
      enabled     = true
    }
    "database-subnet" = {
      description       = "Database servers subnet"
      address          = "10.1.0.0/24"
      enabled          = true
      additional_groups = [data.netbird_group.clients.id]  # Also accessible by clients
    }
  }

  # Enable routing through existing router group
  routing_peer_group_id = data.netbird_group.router_group.id
  
  router_config = {
    metric     = 100
    masquerade = true
    enabled    = true
  }

  # Create access policy
  create_default_policy = true
  allowed_source_groups = [data.netbird_group.clients.id]
  
  policy_config = {
    name          = "Production Network Access"
    description   = "Allow clients to access production resources"
    protocol      = "tcp"
    ports         = ["80", "443", "5432"]
    bidirectional = false
  }

  # Create setup key for router group
  create_setup_key = true
  setup_key_config = {
    name           = "production-router-key"
    type           = "reusable"
    expiry_seconds = 86400  # 24 hours
    usage_limit    = 5
  }
}
```

### Advanced Multi-Group Example

```hcl
# Get existing groups
data "netbird_group" "admins" {
  name = "administrators"
}

data "netbird_group" "developers" {
  name = "developers"
}

data "netbird_group" "routers" {
  name = "edge-routers"
}

module "multi_tier_network" {
  source = "cloudpoet-in/network/netbird"

  network_name        = "multi-tier"
  network_description = "Multi-tier application network with fine-grained access control"

  network_resources = {
    "frontend-lb" = {
      description       = "Frontend load balancer"
      address          = "lb.frontend.local"
      enabled          = true
      additional_groups = [data.netbird_group.developers.id]  # Developers need access for debugging
    }
    "api-cluster" = {
      description = "API server cluster"
      address     = "10.100.0.0/24"
      enabled     = true
    }
    "database-cluster" = {
      description       = "Database cluster subnet"
      address          = "10.200.0.0/24"
      enabled          = true
      additional_groups = [data.netbird_group.admins.id]  # Only admins can access DB directly
    }
    "monitoring" = {
      description       = "Monitoring and observability stack"
      address          = "monitoring.internal"
      enabled          = true
      additional_groups = [data.netbird_group.admins.id, data.netbird_group.developers.id]
    }
  }

  # Configure routing through edge routers
  routing_peer_group_id = data.netbird_group.routers.id
  
  router_config = {
    metric     = 50   # Higher priority than default
    masquerade = true
    enabled    = true
  }

  # Create granular access policy
  create_default_policy = true
  allowed_source_groups = [data.netbird_group.developers.id, data.netbird_group.admins.id]
  
  policy_config = {
    name          = "Multi-tier Application Access"
    description   = "Controlled access to multi-tier application resources"
    protocol      = "tcp"
    ports         = ["80", "443", "8080", "9090"]  # HTTP, HTTPS, Alt HTTP, Monitoring
    bidirectional = false
    enabled       = true
  }

  # Setup key for new router devices
  create_setup_key = true
  setup_key_config = {
    name                   = "multi-tier-router-key"
    type                   = "reusable" 
    expiry_seconds         = 604800  # 7 days
    usage_limit            = 3
    ephemeral              = false
    allow_extra_dns_labels = true
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| netbird | ~> 0.0.3 |

## Providers

| Name | Version |
|------|---------|
| netbird | ~> 0.0.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network_name | Name of the NetBird network | `string` | n/a | yes |
| network_description | Description of the NetBird network | `string` | `""` | no |
| network_resources | Map of network resources to create (keyed by resource identifier) | `map(object({...}))` | `{}` | no |
| routing_peer_group_id | ID of the peer group to use for network routing. Defaults to the group created by this module if not specified. | `string` | `null` | no |
| router_config | Configuration for the network router | `object({...})` | `{}` | no |
| create_default_policy | Whether to create a default access policy for this network | `bool` | `false` | no |
| policy_config | Configuration for the access policy | `object({...})` | `{}` | no |
| allowed_source_groups | List of group IDs that are allowed to access this network | `list(string)` | `[]` | no |
| create_setup_key | Whether to create a setup key for device enrollment | `bool` | `false` | no |
| setup_key_config | Configuration for the setup key | `object({...})` | `{}` | no |

### network_resources

```hcl
network_resources = {
  "resource-key" = {
    description       = string            # Resource description
    address          = string            # IP/CIDR or domain name  
    enabled          = bool              # Whether resource is enabled (optional, default: true)
    additional_groups = list(string)     # Additional group IDs to assign resource to (optional, default: [])
  }
}
```

### policy_config

```hcl
policy_config = {
  name          = string       # Policy name (optional, auto-generated if not provided)
  description   = string       # Policy description (optional, auto-generated if not provided)  
  enabled       = bool         # Whether policy is enabled (optional, default: true)
  rule_name     = string       # Policy rule name (optional, auto-generated if not provided)
  protocol      = string       # Protocol: "all", "tcp", "udp", "icmp" (optional, default: "all")
  action        = string       # Action: "accept" or "drop" (optional, default: "accept")
  bidirectional = bool         # Whether rule is bidirectional (optional, default: false)
  ports         = list(string) # List of ports (optional, default: [])
}
```

### router_config

```hcl
router_config = {
  metric     = number  # Route metric (optional, default: 9999)
  masquerade = bool    # Enable masquerading (optional, default: true)
  enabled    = bool    # Whether router is enabled (optional, default: true)
}
```

### setup_key_config

```hcl
setup_key_config = {
  name                     = string  # Setup key name (optional, auto-generated if not provided)
  type                     = string  # "reusable" or "one-off" (optional, default: "reusable")
  expiry_seconds           = number  # Expiry time in seconds, 0 for unlimited (optional, default: 0)
  usage_limit              = number  # Usage limit, 0 for unlimited (optional, default: 0)
  ephemeral                = bool    # Whether peers are ephemeral (optional, default: false)
  allow_extra_dns_labels   = bool    # Allow extra DNS labels (optional, default: true)
}
```

## Outputs

| Name | Description |
|------|-------------|
| network_id | ID of the created network |
| network_name | Name of the created network |
| default_resource_group_id | ID of the default resource group |
| default_resource_group_name | Name of the default resource group |
| network_resources | Map of network resource IDs keyed by resource name |
| network_resources_details | Map of network resources with full details, keyed by resource name |
| router_id | ID of the network router |
| policy_id | ID of the default access policy (if created) |
| setup_key_id | ID of the setup key (if created) |
| setup_key | The actual setup key for device enrollment (if created, sensitive) |

## Examples

See the [examples](./examples) directory for additional usage examples.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.