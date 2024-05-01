variable "cloudflare_api_token" {
	type        = string
	description = "Cloudflare API Token"
	sensitive   = true
}

variable "zone_id" {
	type        = string
	description = "Cloudflare Zone ID"
	default     = "460c65b55ec2a251ab45cf8eedac4734"
}

variable "cluster_name" {
	description = "The name of the EKS cluster"
	type        = string
	default     = "eks-go-workshop"
}

variable "subdomains" {
	description = "List of subdomains"
	type        = list(string)
	default     = ["group-0", "group-1", "group-2", "group-3", "group-4", "group-5"]
}
