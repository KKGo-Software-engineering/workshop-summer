locals {
  vpc_name     = "go-workshop-vpc"
  cluster_name = "go-workshop-cluster"
}

module "vpc" {
  source       = "./vpc"
  vpc_name     = local.vpc_name
  cluster_name = local.cluster_name
}

module "eks" {
  source               = "./eks"
  cloudflare_api_token = var.cf_api_token
  zone_id              = var.cf_zone_id
  cluster_name         = local.cluster_name
  instance_type        = "t3.medium"
  desired_size         = 2
  max_size             = 3
  min_size             = 2
  subdomains           = var.cf_subdomains
  batch_no             = var.workshop_batch_no
  capacity_type        = "SPOT"
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  nat_id               = module.vpc.nat_id
  subnet_private-1a    = module.vpc.subnet_private-1a
  subnet_private-1b    = module.vpc.subnet_private-1b
  subnet_public-1a     = module.vpc.subnet_public-1a
  subnet_public-1b     = module.vpc.subnet_public-1b
}

module "rds" {
  source      = "./rds"
  db_password = var.rds_db_password
  db_username = var.rds_db_username
  db_name     = "workshop"
  vpc_id      = module.vpc.vpc_id
}

module "sonarqube" {
  source               = "./sonarqube"
  cloudflare_api_token = var.cf_api_token
  instance_type        = "t3.medium"
}
