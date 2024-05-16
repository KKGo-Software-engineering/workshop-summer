output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_private-1a" {
  value = aws_subnet.private-1a.id
}

output "subnet_private-1b" {
  value = aws_subnet.private-1b.id
}

output "subnet_private-1c" {
  value = aws_subnet.public-1a.id
}

output "subnet_public-1a" {
  value = aws_subnet.public-1a.id
}

output "subnet_public-1b" {
  value = aws_subnet.public-1b.id
}

output "subnet_public-1c" {
  value = aws_subnet.public-1c.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_id" {
  value = aws_nat_gateway.nat.id
}
