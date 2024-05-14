# Infrastructure as Code
- [EKS](eks/README.md) - Create EKS cluster, ArgoCD, nginx ingress controller and external-dns
- [ArgoCD](argocd-app/README.md) - Create ArgoCD applications
- [SonarQube](sonarqube/README.md) - Create SonarQube server and mapping DNS to SonarQube
  - DNS `sonarqube`: `sonarqube.werockstar.dev`
  - We're still create project in SonarQube manually
- [Cloudflare](cloudflare/README.md) - Create Cloudflare DNS record for all group
  - Dev
    - `group-1-b1-dev`: `group-1-b1-dev.werockstar.dev`
    - `group-2-b1-dev`: `group-2-b1-dev.werockstar.dev`
    - `group-3-b1-dev`: `group-3-b1-dev.werockstar.dev`
    - `group-4-b1-dev`: `group-4-b1-dev.werockstar.dev`
    - `group-5-b1-dev`: `group-5-b1-dev.werockstar.dev`
  - Prod
    - `group-1-b1-prod`: `group-1-b1-prod.werockstar.dev`
    - `group-2-b1-prod`: `group-2-b1-prod.werockstar.dev`
    - `group-3-b1-prod`: `group-3-b1-prod.werockstar.dev`
    - `group-4-b1-prod`: `group-4-b1-prod.werockstar.dev`
    - `group-5-b1-prod`: `group-5-b1-prod.werockstar.dev`
  - `group-0` is reserved for instructor
    - `group-0-b1-dev`: `group-0-b1-dev.werockstar.dev`
    - `group-0-b1-prod`: `group-0-b1-prod.werockstar.dev`

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | ./eks | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | ./rds | n/a |
| <a name="module_sonarqube"></a> [sonarqube](#module\_sonarqube) | ./sonarqube | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cf_api_token"></a> [cf\_api\_token](#input\_cf\_api\_token) | Cloudflare API Token | `string` | n/a | yes |
| <a name="input_cf_subdomains"></a> [cf\_subdomains](#input\_cf\_subdomains) | List of subdomains | `list(string)` | <pre>[<br>  "group-0",<br>  "group-1",<br>  "group-2",<br>  "group-3",<br>  "group-4",<br>  "group-5"<br>]</pre> | no |
| <a name="input_cf_zone_id"></a> [cf\_zone\_id](#input\_cf\_zone\_id) | Cloudflare Zone ID | `string` | `"460c65b55ec2a251ab45cf8eedac4734"` | no |
| <a name="input_rds_db_name"></a> [rds\_db\_name](#input\_rds\_db\_name) | database name | `string` | `"workshop"` | no |
| <a name="input_rds_db_password"></a> [rds\_db\_password](#input\_rds\_db\_password) | password for db | `string` | n/a | yes |
| <a name="input_rds_db_username"></a> [rds\_db\_username](#input\_rds\_db\_username) | username for db | `string` | n/a | yes |
| <a name="input_workshop_batch_no"></a> [workshop\_batch\_no](#input\_workshop\_batch\_no) | Workshop batch number | `string` | `"b2"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
