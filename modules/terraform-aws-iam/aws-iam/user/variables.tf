variable "user" {
  description = "The user to create"
  type = object({
    name = string
    path = string
    tags = map(any)
    groups = list(string) # group names
  })
  nullable = false
}

variable "aws_region" {
  description = "AWS Region"
}
