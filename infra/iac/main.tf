module "eks" {
  source               = "./eks"
  vpc_name             = "go-workshop-vpc"
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
