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

data "aws_vpc" "main" {
  id = var.vpc_id
}

#checkov:skip=CKV2_AWS_5: "dummy security group"
resource "aws_security_group" "rabbitmq" {
  name        = "test-sg-rabbitmq"
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
  name          = "rabbitmq"
  instance_size = "mq.t3.micro"
  username      = "ExampleUser"
  #checkov:skip=CKV_SECRET_6: "Not a secret"
  password           = random_password.rabbitmq_password.result
  vpc_id             = var.vpc_id
  security_group_ids = [aws_security_group.rabbitmq.id]
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
