terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

}

# Configure the GitHub Provider

provider "aws" {

}

resource "random_password" "rabbitmq_password" {
  length           = 16
  special          = true
  override_special = "!@#$%^&*()_+"
}

resource "random_string" "rabbitmq_name" {
  length  = 5
  special = false
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_security_group" "rabbitmq" {
  #checkov:skip=CKV2_AWS_5: "dummy security group"
  name        = "test-sg-rabbitmq-${random_string.rabbitmq_name.result}"
  vpc_id      = var.vpc_id
  description = "Allow inbound traffic on port 5672 for RabbitMQ"

  ingress {
    from_port   = 5671
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
    description = "Allow RabbitMQ traffic"
  }
}

module "rabbitmq" {
  source        = "./rabbitmq"
  subnet_cidrs  = var.private_subnet_cidrs
  subnet_ids    = var.private_subnet_ids
  name          = "rabbitmq-test-${random_string.rabbitmq_name.result}"
  instance_size = "mq.t3.micro"
  username      = "ExampleUser"
  #checkov:skip=CKV_SECRET_6: "Not a secret"
  password           = random_password.rabbitmq_password.result
  vpc_id             = var.vpc_id
  security_group_ids = [aws_security_group.rabbitmq.id]
  type               = "single-node"
}

output "rabbitmq_id" {
  value = module.rabbitmq.broker_id
}

output "rabbitmq_endpoint" {
  value = module.rabbitmq.broker_endpoint
}

output "rabbitmq_arn" {
  value = module.rabbitmq.broker_arn
}

module "rabbitmq2" {
  source        = "./rabbitmq"
  subnet_cidrs  = var.private_subnet_cidrs
  subnet_ids    = var.private_subnet_ids
  name          = "rabbitmq-test-${random_string.rabbitmq_name.result}-cluster"
  instance_size = "mq.t3.micro"
  username      = "ExampleUser"
  #checkov:skip=CKV_SECRET_6: "Not a secret"
  password           = random_password.rabbitmq_password.result
  vpc_id             = var.vpc_id
  security_group_ids = [aws_security_group.rabbitmq.id]
  type               = "cluster"
  nodes              = 2
}

output "rabbitmq2_id" {
  value = module.rabbitmq2.broker_id
}

output "rabbitmq2_endpoint" {
  value = module.rabbitmq2.broker_endpoint
}

output "rabbitmq2_arn" {
  value = module.rabbitmq2.broker_arn
}
