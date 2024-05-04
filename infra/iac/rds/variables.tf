variable "db_password" {
	type      = string
	sensitive = true
	default   = "password for db"
}

variable "db_username" {
	type      = string
	default   = "username for db"
	sensitive = true
}

variable "db_name" {
	type    = string
	default = "workshop"
	description = "database name"
}
