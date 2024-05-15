resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Cluster = var.cluster_name
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_id
  }

  tags = {
    Cluster = var.cluster_name
  }
}

resource "aws_route_table_association" "public-1a" {
  subnet_id      = var.subnet_public-1a
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-1b" {
  subnet_id      = var.subnet_public-1b
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private-1a" {
  subnet_id      = var.subnet_private-1a
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-1b" {
  subnet_id      = var.subnet_private-1b
  route_table_id = aws_route_table.private.id
}
