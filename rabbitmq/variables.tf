variable "subnet_cidrs" {
  description = "CIDR block for subnet"
  type        = list(string)
  default     = []
}
variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
  default     = []
}

variable "name" {
  description = "Name of the RabbitMQ cluster"
  type        = string
}

variable "instance_size" {
  description = "Size of the RabbitMQ instances"
  type        = string
  validation {
    condition = contains([
      "mq.m6g.xlarge", "mq.r6g.2xlarge", "mq.m7g.4xlarge", "mq.m6i.xlarge", "mq.m7g.2xlarge", "mq.m6g.large",
      "mq.c7a.large", "mq.c6a.large", "mq.m7g.large", "mq.m6gd.2xlarge", "mq.r6g.4xlarge", "mq.c6i.large",
      "mq.c6g.4xlarge", "mq.r7g.2xlarge", "mq.c7i.large", "mq.c7g.large", "mq.c6g.xlarge", "mq.t2.micro",
      "mq.m6i.large", "mq.m7i.large", "mq.m7a.large", "mq.m6a.large", "mq.m5.4xlarge", "mq.m6i.4xlarge",
      "mq.c7g.4xlarge", "mq.r6g.large", "mq.r7g.large", "mq.m4.large", "mq.c6g.large", "mq.r7g.xlarge", "mq.t4g.micro",
      "mq.m6g.4xlarge", "mq.c6g.2xlarge", "mq.c7g.xlarge", "mq.m6i.2xlarge", "mq.m5.xlarge", "mq.m6gd.xlarge",
      "mq.t3.micro", "mq.m6g.2xlarge", "mq.c7g.2xlarge", "mq.r6g.xlarge", "mq.r7g.4xlarge", "mq.m5.2xlarge",
      "mq.m6gd.large", "mq.m6gd.4xlarge", "mq.m5.large", "mq.m7g.xlarge"
    ], var.instance_size)
    error_message = "Invalid instance size"
  }
}

variable "username" {
  description = "Username for RabbitMQ"
  type        = string
}

variable "password" {
  description = "Password for RabbitMQ"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tags" {
  description = "Tags for the RabbitMQ cluster"
  type        = map(string)
  default     = {}
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
  default     = []
}

variable "type" {
  description = "Type of the RabbitMQ cluster"
  type        = string
  default     = "single-node"
  validation {
    condition     = contains(["single-node", "cluster"], var.type)
    error_message = "Invalid type"
  }
}
