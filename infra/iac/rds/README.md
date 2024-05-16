<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_security_group.db-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | database name | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | password for db | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | username for db | `string` | n/a | yes |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Whether the RDS instance is publicly accessible | `bool` | n/a | yes |
| <a name="input_rds_subnet_public-1a"></a> [rds\_subnet\_public-1a](#input\_rds\_subnet\_public-1a) | ID of the public subnet in AZ 1a | `string` | n/a | yes |
| <a name="input_rds_subnet_public-1b"></a> [rds\_subnet\_public-1b](#input\_rds\_subnet\_public-1b) | ID of the public subnet in AZ 1b | `string` | n/a | yes |
| <a name="input_rds_subnet_public-1c"></a> [rds\_subnet\_public-1c](#input\_rds\_subnet\_public-1c) | ID of the public subnet in AZ 1c | `string` | n/a | yes |
| <a name="input_rds_vpc_id"></a> [rds\_vpc\_id](#input\_rds\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_endpoint"></a> [database\_endpoint](#output\_database\_endpoint) | n/a |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | n/a |
| <a name="output_database_port"></a> [database\_port](#output\_database\_port) | n/a |
<!-- END_TF_DOCS -->
