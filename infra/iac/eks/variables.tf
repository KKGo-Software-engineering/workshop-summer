variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "igw_id" {
  description = "The ID of the Internet Gateway"
  type        = string

}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "subnet_private-1a" {
  description = "ID of the private subnet in AZ 1a"
  type        = string
}

variable "subnet_private-1b" {
  description = "ID of the private subnet in AZ 1b"
  type        = string
}

variable "subnet_private-1c" {
  description = "ID of the private subnet in AZ 1c"
  type        = string
}

variable "subnet_public-1a" {
  description = "ID of the public subnet in AZ 1a"
  type        = string
}

variable "subnet_public-1b" {
  description = "ID of the public subnet in AZ 1b"
  type        = string
}

variable "subnet_public-1c" {
  description = "ID of the public subnet in AZ 1c"
  type        = string
}

variable "nat_id" {
  description = "ID of the NAT Gateway"
  type        = string
}

variable "eks_role" {
  description = "The IAM role for the EKS cluster"
  type        = string
  default     = "eks-go-workshop-role"
}

variable "subdomains" {
  description = "List of subdomains"
  type        = list(string)
}

variable "batch_no" {
  description = "Workshop batch number"
  type        = string
  default     = "b2"
}

variable "eks_node_role" {
  description = "The IAM role for the EKS nodes"
  type        = string
  default     = "eks-nodes-role"
}

variable "argocd_namespace" {
  description = "The namespace where ArgoCD is installed"
  type        = string
  default     = "argocd"
}

variable "ingress_namespace" {
  description = "The namespace where the Ingress Controller is installed"
  type        = string
  default     = "ingress-nginx"
}

variable "zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
  default     = "460c65b55ec2a251ab45cf8eedac4734"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API Token"
  sensitive   = true
}

variable "instance_type" {
  description = "The instance type for the EKS nodes"
  type        = string
}

variable "capacity_type" {
  description = "The capacity type for the EKS nodes"
  type        = string
}

variable "min_size" {
  description = "The minimum size of the EKS nodes"
  type        = number
}

variable "max_size" {
  description = "The maximum size of the EKS nodes"
  type        = number
}

variable "desired_size" {
  description = "The desired size of the EKS nodes"
  type        = number
}
