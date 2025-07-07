variable "netbird_token" {
  description = "NetBird Management Access Token"
  type        = string
  sensitive   = true
}

variable "netbird_management_url" {
  description = "NetBird Management API URL"
  type        = string
  default     = "https://api.netbird.io"
}