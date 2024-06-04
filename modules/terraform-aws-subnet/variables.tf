variable "subnet_cidr_block" {
  description = "CIDR block for subnet"
  type        = string
  default     = null
}

variable "subnet_name" {
  description = "Name for subnet"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID"
  default     = null
}

variable "aws_region" {
  description = "AWS Region"
  default     = null
}

variable "aws_role_arn" {
  description = "AWS Role ARN"
  default     = null
}

variable "subnet_tags" {
  description = "Tags"
  type        = map(any)
  default = {
    CreatedBy = "terraform-aws-subnet"
  }
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_az" {
  description = "availability zone"
  type        = string
  default     = null
}
