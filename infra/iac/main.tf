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
  subnet_private-1c    = module.vpc.subnet_private-1c
  subnet_public-1a     = module.vpc.subnet_public-1a
  subnet_public-1b     = module.vpc.subnet_public-1b
  subnet_public-1c     = module.vpc.subnet_public-1c
}

module "rds" {
  source               = "./rds"
  db_password          = var.rds_db_password
  db_username          = var.rds_db_username
  db_name              = var.rds_db_name
  rds_vpc_id           = module.vpc.vpc_id
  rds_subnet_public-1a = module.vpc.subnet_public-1a
  rds_subnet_public-1b = module.vpc.subnet_public-1b
  rds_subnet_public-1c = module.vpc.subnet_public-1c
  publicly_accessible  = true // DON'T DO THIS IN PRODUCTION
}

module "sonarqube" {
  source               = "./sonarqube"
  cloudflare_api_token = var.cf_api_token
  instance_type        = "t3.medium"
}
