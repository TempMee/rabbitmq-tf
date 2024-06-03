# Terraform AWS Subnet module

A simple module that creates subnets for you.

## How to use:

Make sure you have a VPC and know what region you are in.

Apply below module:

```terraform
module "aws-subnet" {
  source = "./aws-subnet"

  subnet_cidr_block = var.subnet_cidr_block
  vpc_id            = aws_vpc.main.id
  subnet_name       = var.subnet_name
  aws_region        = var.aws_region
  aws_role_arn      = var.aws_role_arn
  subnet_tags       = var.subnet_tags
}
```
`aws_role_arn` is optional and can be set to null (or omitted)

## Some built in features

* We automatically add the tag `CreatedBy = "terraform-aws-subnet"` to all subnets. As of now, this can't be turned off.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.73.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws-subnet"></a> [aws-subnet](#module\_aws-subnet) | ./aws-subnet | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `any` | `null` | no |
| <a name="input_aws_role_arn"></a> [aws\_role\_arn](#input\_aws\_role\_arn) | AWS Role ARN | `any` | `null` | no |
| <a name="input_subnet_az"></a> [subnet\_az](#input\_subnet\_az) | availability zone | `string` | `null` | no |
| <a name="input_subnet_cidr_block"></a> [subnet\_cidr\_block](#input\_subnet\_cidr\_block) | CIDR block for subnet | `string` | `null` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Name for subnet | `string` | `null` | no |
| <a name="input_subnet_tags"></a> [subnet\_tags](#input\_subnet\_tags) | Tags | `map(any)` | <pre>{<br>  "CreatedBy": "terraform-aws-subnet"<br>}</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
<!-- END_TF_DOCS -->
<!-- END_TF_DOCS -->
