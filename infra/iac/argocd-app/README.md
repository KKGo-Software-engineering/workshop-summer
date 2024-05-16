# Terraform for Create ArgoCD Application
This module intended to create ArgoCD application for EKS cluster

## Preparation
- Create Terraform workspace
	- `dev` for development environment
	- `prod` for production environment


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8.0 |
| <a name="requirement_argocd"></a> [argocd](#requirement\_argocd) | >= 6.0.0, < 7.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.13 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.0.0, < 2.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.0, < 3.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_argocd"></a> [argocd](#provider\_argocd) | >= 6.0.0, < 7.0.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [argocd_application.argocd_app](https://registry.terraform.io/providers/oboukili/argocd/latest/docs/resources/application) | resource |
| [aws_eks_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argo_apps"></a> [argo\_apps](#input\_argo\_apps) | List of groups to create in ArgoCD application | `list(string)` | <pre>[<br>  "group-0",<br>  "group-1",<br>  "group-2",<br>  "group-3",<br>  "group-4",<br>  "group-5"<br>]</pre> | no |
| <a name="input_argocd_password"></a> [argocd\_password](#input\_argocd\_password) | ArgoCD password | `string` | n/a | yes |
| <a name="input_argocd_server_addr"></a> [argocd\_server\_addr](#input\_argocd\_server\_addr) | ArgoCD server address | `string` | `"argocd.werockstar.dev:443"` | no |
| <a name="input_argocd_username"></a> [argocd\_username](#input\_argocd\_username) | ArgoCD username | `string` | `"admin"` | no |
| <a name="input_batch_no"></a> [batch\_no](#input\_batch\_no) | Workshop batch number | `string` | `"b2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster | `string` | `"eks-go-workshop"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
