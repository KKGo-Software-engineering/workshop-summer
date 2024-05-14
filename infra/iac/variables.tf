variable "cf_zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
  default     = "460c65b55ec2a251ab45cf8eedac4734"
}

variable "cf_api_token" {
  type        = string
  description = "Cloudflare API Token"
  sensitive   = true
}
