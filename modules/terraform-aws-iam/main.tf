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


provider "aws" {
  region = var.aws_region
  alias  = "target"
  assume_role {
    role_arn = var.aws_role_arn
  }
}

###############################################################################
#
#  Test 1 - Create user with group and policy
#
###############################################################################
data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["ec2:Describe*"]
    effect    = "Allow"
    resources = ["*"]
  }
}

module "test-policy" {
  source       = "./aws-iam/policy"
  aws_region   = var.aws_region

  policy = {
    name        = "test-policy"
    description = "test policy"
    path        = "/"
    tags = {}

    policy = data.aws_iam_policy_document.example.json
  }
}


module "test-group" {
  source       = "./aws-iam/group"
  aws_region   = var.aws_region

  group = {
    name     = "test-group"
    path     = "/"
    policies = [module.test-policy.policy_arn]
  }
}

module "test-user" {
  source       = "./aws-iam/user"
  aws_region   = var.aws_region

  user = {
    name   = "test-user"
    path   = "/"
    groups = [module.test-group.group.name]
    tags = {

    }
  }
}


###############################################################################
#
#  Test 2 - Create user with group and policy, and create roles with
#           assume role policy
#
###############################################################################

data "aws_iam_policy_document" "example2" {
  statement {
    actions   = ["ec2:Describe*"]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "assume_role_dummy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [module.dummy_role.role_arn]
    }
  }
}

data "aws_iam_policy_document" "allow_assume_dummy_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    resources = [module.dummy_role.role_arn]
  }
}

module "test-policy2" {
  source       = "./aws-iam/policy"
  aws_region   = var.aws_region

  policy = {
    name        = "test-policy2"
    description = "test policy2"
    path        = "/"
    tags = {}

    policy = data.aws_iam_policy_document.allow_assume_dummy_role.json
  }
}

module "test-group2" {
  source       = "./aws-iam/group"
  aws_region   = var.aws_region

  group = {
    name     = "test-group2"
    path     = "/test2/"
    policies = [module.test-policy2.policy_arn]
  }

}

data "aws_iam_policy" "test_policy2_arn" {
  arn = module.test-policy2.policy_arn
  depends_on = [
    module.test-policy2
  ]
}

module "test-user2" {
  source       = "./aws-iam/user"
  aws_region   = var.aws_region

  user = {
    name   = "test-user2"
    path   = "/test2/"
    groups = [module.test-group2.group.name]
    tags = {

    }
  }
}

module "dummy_role" {
  source       = "./aws-iam/role"
  aws_region   = var.aws_region

  role = {
    name        = "dummy-role"
    description = "dummy role"
    path        = "/"

    assume_role_policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }
}
    EOT

    tags = {

    }
    policies = []
  }
}

module "test-role2" {
  source       = "./aws-iam/role"
  aws_region   = var.aws_region

  role = {
    name        = "test-role2"
    description = "test role2"
    path        = "/"

    assume_role_policy = data.aws_iam_policy_document.assume_role_dummy.json

    tags = {

    }
    policies = [module.test-policy2.policy_arn]
  }
}

