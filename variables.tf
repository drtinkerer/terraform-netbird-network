variable "network_name" {
  description = "Name of the NetBird network"
  type        = string
}

variable "network_description" {
  description = "Description of the NetBird network"
  type        = string
  default     = ""
}

variable "group_name" {
  description = "Name of the group for network access"
  type        = string
}

variable "network_resources" {
  description = "List of network resources to create"
  type = list(object({
    name        = string
    description = string
    address     = string
    enabled     = optional(bool, true)
  }))
  default = []
}

variable "setup_key_name" {
  description = "Name of the setup key"
  type        = string
  default     = "Setup Key"
}

variable "setup_key_config" {
  description = "Configuration for the setup key"
  type = object({
    type                     = optional(string, "reusable")
    expiry_seconds           = optional(number, 0)
    usage_limit              = optional(number, 0)
    ephemeral                = optional(bool, false)
    allow_extra_dns_labels   = optional(bool, true)
  })
  default = {}
}

variable "enable_routing" {
  description = "Enable network routing for the group"
  type        = bool
  default     = true
}

variable "router_config" {
  description = "Configuration for the network router"
  type = object({
    metric     = optional(number, 9999)
    masquerade = optional(bool, true)
  })
  default = {}
}

variable "allowed_source_groups" {
  description = "List of group names that should have access to this group"
  type        = list(string)
  default     = ["All"]
}

variable "create_access_policy" {
  description = "Create policy to allow specified groups to access this group"
  type        = bool
  default     = true
}