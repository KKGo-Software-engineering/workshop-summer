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
  publicly_accessible                   = var.publicly_accessible
  availability_zone                     = "ap-southeast-1a"

  tags = {
    Name = "database-workshop"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = [var.rds_subnet_public-1a, var.rds_subnet_public-1b, var.rds_subnet_public-1c]
  name       = "database-workshop-subnet-group"
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
  name        = "database-workshop-sg"
  description = "Allow traffic to PostgreSQL database"
  vpc_id      = var.rds_vpc_id

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
