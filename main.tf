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


module "rabbitmq" {
  source        = "./rabbitmq"
  subnet_cidrs  = var.private_subnet_cidrs
  subnet_ids    = var.private_subnet_ids
  name          = "rabbitmq"
  instance_size = "mq.t3.micro"
  username      = "ExampleUser"
  password      = "MindTheGap123"
  vpc_id        = var.vpc_id
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

