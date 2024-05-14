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

variable "cf_subdomains" {
  description = "List of subdomains"
  type        = list(string)
  default     = ["group-0", "group-1", "group-2", "group-3", "group-4", "group-5"]
}

variable "workshop_batch_no" {
  description = "Workshop batch number"
  type        = string
  default     = "b2"
}
