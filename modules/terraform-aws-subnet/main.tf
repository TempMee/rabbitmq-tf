terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
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

resource "aws_vpc" "main" {
  #checkov:skip=CKV2_AWS_11:No resources
  #checkov:skip=CKV2_AWS_12:No resources
  cidr_block = var.vpc_cidr
}

module "aws-subnet" {
  source = "./aws-subnet"

  subnet_cidr_block = var.subnet_cidr_block
  vpc_id            = aws_vpc.main.id
  subnet_name       = var.subnet_name
  subnet_tags       = var.subnet_tags
  subnet_az         = var.subnet_az
}


output "vpc_id" {
  value = aws_vpc.main.id
}
