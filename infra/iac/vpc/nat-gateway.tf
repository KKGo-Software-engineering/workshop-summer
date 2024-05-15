resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-1a.id

  tags = {
    Cluster = var.cluster_name
    Name    = var.nat_name
  }

  depends_on = [aws_internet_gateway.igw]
}
