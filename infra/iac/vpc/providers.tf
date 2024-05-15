terraform {
	required_version = "~> 1.8.0"
	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = "~> 5.48.0"
		}
	}
}

provider "aws" {
	region = "ap-southeast-1"
}
