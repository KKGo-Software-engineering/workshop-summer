resource "aws_vpc" "vpc" {
	cidr_block = "10.0.0.0/16"

	tags = {
		Name    = var.vpc_name
		Cluster = var.cluster_name
	}
	enable_dns_support   = true
	enable_dns_hostnames = true
}
