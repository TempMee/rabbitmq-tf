terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

data "aws_vpc" "vpc" {
  # use the vpc passed as input. If no input, use the one from remote state in network-infrastructure.
  id = var.vpc_id
}

resource "aws_subnet" "subnet" {
  vpc_id     = data.aws_vpc.vpc.id
  cidr_block = var.subnet_cidr_block

  availability_zone = var.subnet_az

  map_public_ip_on_launch = false
  tags = merge({
    Name      = var.subnet_name
    CreatedBy = "terraform-aws-subnet"
  }, var.subnet_tags)
}
