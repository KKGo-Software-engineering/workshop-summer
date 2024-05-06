terraform {
	required_version = "~> 1.8.0"
	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = "~> 5.48.0"
		}
		kubectl = {
			source  = "gavinbunney/kubectl"
			version = "1.14.0"
		}
		null = {
			source  = "hashicorp/null"
			version = "3.2.2"
		}
		kubernetes = {
			source  = "hashicorp/kubernetes"
			version = "2.29.0"
		}
		argocd = {
			source  = "oboukili/argocd"
			version = "6.1.1"
		}
		helm = {
			source  = "hashicorp/helm"
			version = "~> 2.13"
		}
		cloudflare = {
			source  = "cloudflare/cloudflare"
			version = "4.31.0"
		}
	}
}

provider "aws" {
	region = "ap-southeast-1"
}

provider "cloudflare" {
	api_token = var.cloudflare_api_token
}
