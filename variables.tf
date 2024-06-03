variable "private_subnet_cidrs" {
    description = "Private Subnet CIDRs used for databricks to know where to deploy ec2 instances"
    type        = set(string)

}

variable "private_subnet_ids" {
  description = "Private Subnet IDs used for databricks to know where to deploy ec2 instances"
  type        = set(string)
}

variable "public_subnet_id" {
  description = "Public Subnet ID used for creating igw"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  default     = null
}