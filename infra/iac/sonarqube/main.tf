resource "aws_key_pair" "deployer" {
	key_name   = "${var.instance_name}-key"
	public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "sonarqube-vpc" {
	cidr_block = "10.0.0.0/16"

	tags = {
		Name = "${var.instance_name}-vpc"
	}
}

resource "aws_subnet" "public-1a" {
	vpc_id                  = aws_vpc.sonarqube-vpc.id
	cidr_block              = "10.0.1.0/24"
	availability_zone       = "ap-southeast-1a"
	map_public_ip_on_launch = true


	tags = {
		Name = "${var.instance_name}-public-1a"
	}
}

resource "aws_route_table_association" "sonarqube-rt-assoc" {
	subnet_id      = aws_subnet.public-1a.id
	route_table_id = aws_route_table.sonarqube-rt.id

}

resource "aws_route_table" "sonarqube-rt" {
	vpc_id = aws_vpc.sonarqube-vpc.id

	route {
		gateway_id = aws_internet_gateway.sonarqube-igw.id
		cidr_block = "0.0.0.0/0"
	}

	tags = {
		Name = "${var.instance_name}-rt"
	}
}

resource "aws_internet_gateway" "sonarqube-igw" {
	vpc_id = aws_vpc.sonarqube-vpc.id

	tags = {
		Name = "${var.instance_name}-igw"
	}
}

resource "aws_security_group" "sonarqube-sg" {
	vpc_id = aws_vpc.sonarqube-vpc.id
	name   = "${var.instance_name}-sg"
	tags = {
		Name = "${var.instance_name}-sg"
	}

	// DO NOT USE THIS IN PRODUCTION
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_instance" "sonarqube" {
	ami                    = "ami-02a96df5f84f42942"
	instance_type          = "t2.medium"
	key_name               = aws_key_pair.deployer.key_name
	vpc_security_group_ids = [aws_security_group.sonarqube-sg.id]
	subnet_id              = aws_subnet.public-1a.id

	tags = {
		Name = "sonarqube"
	}
	associate_public_ip_address = true
}

resource "local_file" "ansible_inventory" {
	content = templatefile("ansible/templates/sonarqube.ini", {
		instance_ip = aws_instance.sonarqube.public_ip
	})
	filename = "ansible/inventories/sonarqube.ini"
}

resource "cloudflare_record" "sonarqube" {
	name    = "sonarqube"
	value   = aws_instance.sonarqube.public_ip
	type    = "A"
	proxied = true
	zone_id = var.zone_id
}
