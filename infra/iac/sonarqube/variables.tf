variable "zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API Token"
  sensitive   = true
}

variable "instance_name" {
  type        = string
  description = "Name of the instance"
  default     = "sonarqube"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}
