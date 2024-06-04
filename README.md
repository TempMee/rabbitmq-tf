# terraform-template
Terraform repo template

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.50.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rabbitmq"></a> [rabbitmq](#module\_rabbitmq) | ./rabbitmq | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.rabbitmq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.rabbitmq_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | Private Subnet CIDRs used for databricks to know where to deploy ec2 instances | `set(string)` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private Subnet IDs used for databricks to know where to deploy ec2 instances | `set(string)` | n/a | yes |
| <a name="input_public_subnet_id"></a> [public\_subnet\_id](#input\_public\_subnet\_id) | Public Subnet ID used for creating igw | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rabbitmq_arn"></a> [rabbitmq\_arn](#output\_rabbitmq\_arn) | n/a |
| <a name="output_rabbitmq_endpoint"></a> [rabbitmq\_endpoint](#output\_rabbitmq\_endpoint) | n/a |
| <a name="output_rabbitmq_id"></a> [rabbitmq\_id](#output\_rabbitmq\_id) | n/a |
<!-- END_TF_DOCS -->
