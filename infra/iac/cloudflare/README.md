# Terraform for Cloudflare
This module intended to map DNS for each group in Go workshop.

## Preparation
- Create Terraform workspace
  - `dev` for development environment
  - `prod` for production environment

- Dev
	- `group-1-dev`: `group-1-dev.werockstar.dev`
	- `group-2-dev`: `group-2-dev.werockstar.dev`
	- `group-3-dev`: `group-3-dev.werockstar.dev`
	- `group-4-dev`: `group-4-dev.werockstar.dev`
	- `group-5-dev`: `group-5-dev.werockstar.dev`
- Prod
	- `group-1-prod`: `group-1-prod.werockstar.dev`
	- `group-2-prod`: `group-2-prod.werockstar.dev`
	- `group-3-prod`: `group-3-prod.werockstar.dev`
	- `group-4-prod`: `group-4-prod.werockstar.dev`
	- `group-5-prod`: `group-5-prod.werockstar.dev`

## Requirements
- Cloudflare API Token

```sh
terraform init
terraform plan
terraform apply -var 'cloudflare_api_token=xxx' -auto-approve
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | >= 4.0.0, < 5.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.0, < 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.47.0 |
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 4.30.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.29.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_record.all-groups](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [aws_eks_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [kubernetes_service.service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_api_token"></a> [cloudflare\_api\_token](#input\_cloudflare\_api\_token) | Cloudflare API Token | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster | `string` | `"eks-go-workshop"` | no |
| <a name="input_subdomains"></a> [subdomains](#input\_subdomains) | List of subdomains | `list(string)` | <pre>[<br>  "group-0",<br>  "group-1",<br>  "group-2",<br>  "group-3",<br>  "group-4",<br>  "group-5"<br>]</pre> | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Cloudflare Zone ID | `string` | `"460c65b55ec2a251ab45cf8eedac4734"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
