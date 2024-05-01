variable "argocd_password" {
	description = "ArgoCD password"
	type        = string
	sensitive   = true
}

variable "argocd_username" {
	description = "ArgoCD username"
	type        = string
	default     = "admin"
}

variable "argocd_server_addr" {
	description = "ArgoCD server address"
	type        = string
	default     = "argocd.werockstar.dev:443"
}

variable "cluster_name" {
	description = "The name of the EKS cluster"
	type        = string
	default     = "eks-go-workshop"
}

variable "argo_apps" {
	description = "List of groups to create in ArgoCD application"
	type        = list(string)
	default     = ["group-0", "group-1", "group-2", "group-3", "group-4", "group-5"]
}
