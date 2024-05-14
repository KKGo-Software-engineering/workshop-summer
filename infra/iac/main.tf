module "eks" {
  source               = "./eks"
  vpc_name             = "go-workshop-vpc"
  cloudflare_api_token = var.cf_api_token
  zone_id              = var.cf_zone_id
}
