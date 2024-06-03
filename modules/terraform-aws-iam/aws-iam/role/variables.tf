variable "role" {
  description = "The role to create"
  type = object({
    name = string
    path = string
    tags = map(any)
    assume_role_policy = string
    policies = list(string) # policy arn
  })
  nullable = false
}

variable "aws_region" {
  description = "AWS Region"
}
