variable "db_password" {
  type        = string
  sensitive   = true
  description = "password for db"
}

variable "db_username" {
  type        = string
  description = "username for db"
  sensitive   = true
}

variable "db_name" {
  type        = string
  description = "database name"
}

variable "rds_vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "rds_subnet_public-1a" {
  description = "ID of the public subnet in AZ 1a"
  type        = string
}

variable "rds_subnet_public-1b" {
  description = "ID of the public subnet in AZ 1b"
  type        = string
}

variable "rds_subnet_public-1c" {
  description = "ID of the public subnet in AZ 1c"
  type        = string
}

variable "publicly_accessible" {
  type        = bool
  description = "Whether the RDS instance is publicly accessible"
}
