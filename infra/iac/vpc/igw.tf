resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Cluster = var.cluster_name
    Name    = "${var.cluster_name}-igw"
  }
}
