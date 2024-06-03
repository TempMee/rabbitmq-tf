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
  source = "./rabbitmq"
  private_subnet_cidrs = var.private_subnet_ids
}