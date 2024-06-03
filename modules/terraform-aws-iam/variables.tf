variable "user" {
  description = "The user to create"
  type = object({
    name = string
    path = string
    tags = map(any)
    groups = list(string) # group names
  })
  default = null
}

variable "role" {
  description = "The role to create"
  type = object({
    name = string
    path = string
    tags = map(any)
    policies = list(string) # policy names
  })
  default = null
}

variable "policy" {
  description = "Policy"
  type = object({
    name        = string
    path        = string
    description = string
    policy      = string # policy
  })
  default = null
}

variable "group" {
  description = "Name and path of group"
  type = object({
    name  = string
    path  = string
    policies = list(string) # policy arns
  })
  default = null
}

variable "aws_region" {
  description = "AWS Region"
  default     = null
}

variable "aws_role_arn" {
  description = "AWS Role ARN"
  default     = null
}
