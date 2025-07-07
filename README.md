# Terraform NetBird Network Module

A Terraform module for creating and managing NetBird networks with automatic peer grouping, network resources, routing, and access policies.

## Features

- **Network Creation**: Create NetBird networks with custom descriptions
- **Auto-assigned Groups**: Automatically assign peers using setup keys to designated groups
- **Network Resources**: Support for both CIDR blocks and domain names
- **Routing Configuration**: Optional network routing with configurable metrics and masquerading
- **Access Policies**: Flexible access control with configurable source groups
- **Setup Keys**: Generate reusable or one-time setup keys for device enrollment

## Usage

### Basic Example

```hcl
module "homelab_network" {
  source = "cloudpoet-in/network/netbird"

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
      name        = "NAS Server"
      description = "Network attached storage"
      address     = "nas.home.local"
      enabled     = true
    }
  ]

  allowed_source_groups = ["All"]
}
```

### Without Setup Key

```hcl
module "network_only" {
  source = "cloudpoet-in/network/netbird"

  network_name        = "Network Only"
  network_description = "Network without setup key"
  group_name          = "Manual-Group"
  
  create_setup_key = false  # Disable setup key creation
  
  network_resources = [
    {
      name        = "Internal Services"
      description = "Internal API services"
      address     = "10.0.1.0/24"
      enabled     = true
    }
  ]
}
```

### Advanced Example

```hcl
module "production_network" {
  source = "./modules/netbird-network"

  network_name        = "Production"
  network_description = "Production environment network"
  group_name          = "Prod-Auto-Assigned"
  setup_key_name      = "Production Setup Key"

  network_resources = [
    {
      name        = "Production LAN"
      description = "Production network"
      address     = "10.0.0.0/16"
      enabled     = true
    },
    {
      name        = "Database Subnet"
      description = "Database servers"
      address     = "10.1.0.0/24"
      enabled     = true
    },
    {
      name        = "API Gateway"
      description = "Production API gateway"
      address     = "api.company.com"
      enabled     = true
    }
  ]

  setup_key_config = {
    type                     = "reusable"
    expiry_seconds           = 86400  # 24 hours
    usage_limit              = 10
    ephemeral                = false
    allow_extra_dns_labels   = true
  }

  router_config = {
    metric     = 100
    masquerade = true
  }

  allowed_source_groups = ["All"]  # Add other existing groups as needed
  create_access_policy  = true
  enable_routing        = true
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| netbird | >= 0.0.3 |

## Providers

| Name | Version |
|------|---------|
| netbird | >= 0.0.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network_name | Name of the NetBird network | `string` | n/a | yes |
| group_name | Name of the group for network access | `string` | n/a | yes |
| network_description | Description of the NetBird network | `string` | `""` | no |
| network_resources | List of network resources to create | `list(object({...}))` | `[]` | no |
| setup_key_name | Name of the setup key | `string` | `"Setup Key"` | no |
| setup_key_config | Configuration for the setup key | `object({...})` | `{}` | no |
| allowed_source_groups | List of group names that should have access to this group | `list(string)` | `["All"]` | no |
| create_setup_key | Whether to create a setup key for the group | `bool` | `true` | no |
| enable_routing | Enable network routing for the group | `bool` | `true` | no |
| router_config | Configuration for the network router | `object({...})` | `{}` | no |
| create_access_policy | Create policy to allow specified groups to access this group | `bool` | `true` | no |

### network_resources

```hcl
network_resources = [
  {
    name        = string  # Resource name
    description = string  # Resource description
    address     = string  # IP/CIDR or domain name
    enabled     = bool    # Whether resource is enabled (optional, default: true)
  }
]
```

### setup_key_config

```hcl
setup_key_config = {
  type                     = string  # "reusable" or "one-off" (optional, default: "reusable")
  expiry_seconds           = number  # Expiry time in seconds, 0 for unlimited (optional, default: 0)
  usage_limit              = number  # Usage limit, 0 for unlimited (optional, default: 0)
  ephemeral                = bool    # Whether peers are ephemeral (optional, default: false)
  allow_extra_dns_labels   = bool    # Allow extra DNS labels (optional, default: true)
}
```

### router_config

```hcl
router_config = {
  metric     = number  # Route metric (optional, default: 9999)
  masquerade = bool    # Enable masquerading (optional, default: true)
}
```

## Outputs

| Name | Description |
|------|-------------|
| network_id | ID of the created network |
| network_name | Name of the created network |
| group_id | ID of the created group |
| group_name | Name of the created group |
| setup_key_id | ID of the setup key (if created) |
| setup_key | The setup key for devices (if created, sensitive) |
| network_resources | Map of network resources created |
| router_id | ID of the network router (if enabled) |
| policy_id | ID of the access policy (if created) |

## Examples

See the [examples](./examples) directory for additional usage examples.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.