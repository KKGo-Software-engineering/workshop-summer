terraform {
	required_version = "~> 1.8.0"
	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = "~> 5.0"
		}
		kubectl = {
			source  = "gavinbunney/kubectl"
			version = ">= 1.0.0, < 2.0.0"
		}
		null = {
			source  = "hashicorp/null"
			version = ">= 3.0.0"
		}
		kubernetes = {
			source  = "hashicorp/kubernetes"
			version = ">= 2.0.0, < 3.0.0"
		}
		argocd = {
			source  = "oboukili/argocd"
			version = ">= 6.0.0, < 7.0.0"
		}
		helm = {
			source  = "hashicorp/helm"
			version = "~> 2.13"
		}
		cloudflare = {
			source  = "cloudflare/cloudflare"
			version = ">= 4.0.0, < 5.0.0"
		}
	}
}

provider "aws" {
	region = "ap-southeast-1"
}

provider "cloudflare" {
	api_token = var.cloudflare_api_token
}
