terraform {
	required_version = "~> 1.8.0"
	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = "~> 5.0"
		}
		null = {
			source  = "hashicorp/null"
			version = ">= 3.0.0"
		}
	}
}

provider "aws" {
	region = "ap-southeast-1"
}
