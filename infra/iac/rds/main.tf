resource "aws_db_instance" "postgres" {
  allocated_storage                     = 20
  storage_type                          = "gp2"
  engine                                = "postgres"
  engine_version                        = "16.1"
  instance_class                        = "db.t3.micro"
  identifier                            = "database-workshop"
  username                              = var.db_username
  password                              = var.db_password
  db_name                               = var.db_name
  multi_az                              = false
  skip_final_snapshot                   = false
  final_snapshot_identifier             = "database-workshop-snapshot"
  vpc_security_group_ids                = [aws_security_group.db-sg.id]
  db_subnet_group_name                  = aws_db_subnet_group.db_subnet_group.name
  backup_retention_period               = 7
  parameter_group_name                  = "default.postgres16"
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  publicly_accessible                   = true // DON'T DO THIS IN PRODUCTION
  availability_zone                     = "ap-southeast-1c"

  tags = {
    Name = "database-workshop"
  }
}

resource "aws_subnet" "public-1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "ap-southeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "workshop-public-1c"
  }
}

resource "aws_subnet" "public-1b" {
	vpc_id                  = var.vpc_id
	cidr_block              = "10.0.6.0/24"
	availability_zone       = "ap-southeast-1b"
	map_public_ip_on_launch = true

	tags = {
		Name = "workshop-public-1b"
	}
}

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = [aws_subnet.public-1c.id, aws_subnet.public-1b.id]
}

output "database_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "database_port" {
  value = aws_db_instance.postgres.port
}

output "database_name" {
  value = aws_db_instance.postgres.db_name
}

resource "aws_security_group" "db-sg" {
  name        = "database-workshop"
  description = "Allow traffic to PostgreSQL database"
  vpc_id      = var.vpc_id

  # DON'T DO THIS IN PRODUCTION
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-sg"
  }
}
