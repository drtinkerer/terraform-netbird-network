variable "network_name" {
  description = "Name of the NetBird network"
  type        = string
}

variable "network_description" {
  description = "Description of the NetBird network"
  type        = string
  default     = ""
}

variable "network_resources" {
  description = "Map of network resources to create (keyed by resource identifier)"
  type = map(object({
    description       = string
    address           = string
    enabled           = optional(bool, true)
    additional_groups = optional(list(string), [])
  }))
  default = {}
}

variable "routing_peer_group_id" {
  description = "ID of the peer group to use for network routing. Defaults to the group created by this module if not specified."
  type        = string
  default     = null
}

variable "router_config" {
  description = "Configuration for the network router"
  type = object({
    metric     = optional(number, 9999)
    masquerade = optional(bool, true)
    enabled    = optional(bool, true)
  })
  default = {}
}

variable "create_default_policy" {
  description = "Whether to create a default access policy for this network"
  type        = bool
  default     = false
}

variable "policy_config" {
  description = "Configuration for the access policy"
  type = object({
    name          = optional(string)
    description   = optional(string)
    enabled       = optional(bool, true)
    rule_name     = optional(string)
    protocol      = optional(string, "all")
    action        = optional(string, "accept")
    bidirectional = optional(bool, false)
    ports         = optional(list(string), [])
  })
  default = {}
}

variable "allowed_source_groups" {
  description = "List of group IDs that are allowed to access this network"
  type        = list(string)
  default     = []
}

variable "create_setup_key" {
  description = "Whether to create a setup key for device enrollment"
  type        = bool
  default     = false
}

variable "setup_key_config" {
  description = "Configuration for the setup key"
  type = object({
    name                   = optional(string)
    type                   = optional(string, "reusable")
    expiry_seconds         = optional(number, 0)
    usage_limit            = optional(number, 0)
    ephemeral              = optional(bool, false)
    allow_extra_dns_labels = optional(bool, true)
  })
  default = {}
}
