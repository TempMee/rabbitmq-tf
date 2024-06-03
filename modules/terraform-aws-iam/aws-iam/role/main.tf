terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

resource "aws_iam_role" "role" {
  name = var.role.name
  path = var.role.path

  force_detach_policies = true

  assume_role_policy = var.role.assume_role_policy
  tags = merge({
    createdBy = "terraform aws-iam/role"
  }, var.role.tags)
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  for_each   = toset(var.role.policies)
  role       = aws_iam_role.role.name
  policy_arn = each.value
  depends_on = [
    aws_iam_role.role,
  ]
}

# we compose arn here as role is created where we have access wether this is from 
# assume role or the user actually accessing.
locals {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role${var.role.path != null ? "${var.role.path}" : "/"}${var.role.name}"
}

data "aws_caller_identity" "current" {}
