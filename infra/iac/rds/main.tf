resource "aws_db_instance" "postgres" {
	allocated_storage       = 20
	storage_type            = "gp2"
	engine                  = "postgres"
	engine_version          = "16.1"
	instance_class          = "db.t3.micro"
	identifier              = "database-workshop"
	username                = var.db_username
	password                = var.db_password
	db_name                 = var.db_name
	multi_az                = false
	skip_final_snapshot     = false
	vpc_security_group_ids  = [aws_security_group.db-sg.id]
	backup_retention_period = 7
	parameter_group_name    = "default.postgres16"

	tags = {
		Name = "database-workshop"
	}
}

data "aws_vpc" "default" {
	default = true
}

resource "aws_security_group" "db-sg" {
	name        = "database-workshop"
	description = "Allow traffic to PostgreSQL database"
	vpc_id      = data.aws_vpc.default.id

	# DON'T DO THIS IN PRODUCTION
	ingress {
		from_port   = 5432
		to_port     = 5432
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "database-sg"
	}
}
