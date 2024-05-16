variable "vpc_name" {
  description = "The name of VPC"
  type        = string
}

variable "cluster_name" {
  description = "The name of cluster"
  type        = string
}

variable "nat_name" {
  description = "The name of the NAT Gateway"
  type        = string
  default     = "go-workshop-nat"
}
