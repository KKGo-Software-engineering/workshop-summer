locals {
  vpc_name = "go-workshop-vpc"
}

module "eks" {
  source               = "./eks"
  vpc_name             = local.vpc_name
  cloudflare_api_token = var.cf_api_token
  zone_id              = var.cf_zone_id
  instance_type        = "t3.medium"
  desired_size         = 2
  max_size             = 3
  min_size             = 2
  subdomains           = var.cf_subdomains
  batch_no             = var.workshop_batch_no
  capacity_type        = "ON_DEMAND"
}

module "rds" {
  source      = "./rds"
  db_password = var.rds_db_password
  db_username = var.rds_db_username
  db_name     = "workshop"
}

module "sonarqube" {
  source               = "./sonarqube"
  cloudflare_api_token = var.cf_api_token
  instance_type        = "t3.medium"
}
