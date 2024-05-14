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
