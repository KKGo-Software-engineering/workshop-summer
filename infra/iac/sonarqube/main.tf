resource "aws_key_pair" "deployer" {
	key_name   = "deployer-key"
	public_key = file("~/.ssh/id_rsa.pub")
}

data "aws_vpc" "default" {
	default = true
}

data "aws_subnet" "selected" {
	id = "subnet-0f94565b4850d1e55"
}

// Don't this at home
resource "aws_security_group" "sonarqube-sg" {
	vpc_id = data.aws_vpc.default.id
	name   = "sonarqube-sg"
	tags = {
		Name = "sonarqube-sg"
	}

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
	subnet_id              = data.aws_subnet.selected.id
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
