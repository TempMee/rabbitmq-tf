# Terraform AWS IAM
A module to make creating IAM securely.

## Restrictions
* User cannot be created with inline policies
* User cannot be created without being added to a group

See inside each submodule for details on the module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.76.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dummy_role"></a> [dummy\_role](#module\_dummy\_role) | ./aws-iam/role | n/a |
| <a name="module_test-group"></a> [test-group](#module\_test-group) | ./aws-iam/group | n/a |
| <a name="module_test-group2"></a> [test-group2](#module\_test-group2) | ./aws-iam/group | n/a |
| <a name="module_test-policy"></a> [test-policy](#module\_test-policy) | ./aws-iam/policy | n/a |
| <a name="module_test-policy2"></a> [test-policy2](#module\_test-policy2) | ./aws-iam/policy | n/a |
| <a name="module_test-role2"></a> [test-role2](#module\_test-role2) | ./aws-iam/role | n/a |
| <a name="module_test-user"></a> [test-user](#module\_test-user) | ./aws-iam/user | n/a |
| <a name="module_test-user2"></a> [test-user2](#module\_test-user2) | ./aws-iam/user | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.test_policy2_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.allow_assume_dummy_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role_dummy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.example2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `any` | `null` | no |
| <a name="input_aws_role_arn"></a> [aws\_role\_arn](#input\_aws\_role\_arn) | AWS Role ARN | `any` | `null` | no |
| <a name="input_group"></a> [group](#input\_group) | Name and path of group | <pre>object({<br>    name     = string<br>    path     = string<br>    policies = list(string) # policy arns<br>  })</pre> | `null` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | Policy | <pre>object({<br>    name        = string<br>    path        = string<br>    description = string<br>    policy      = string # policy<br>  })</pre> | `null` | no |
| <a name="input_role"></a> [role](#input\_role) | The role to create | <pre>object({<br>    name     = string<br>    path     = string<br>    tags     = map(any)<br>    policies = list(string) # policy names<br>  })</pre> | `null` | no |
| <a name="input_user"></a> [user](#input\_user) | The user to create | <pre>object({<br>    name   = string<br>    path   = string<br>    tags   = map(any)<br>    groups = list(string) # group names<br>  })</pre> | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
