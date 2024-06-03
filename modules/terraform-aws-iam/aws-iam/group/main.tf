terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

resource "aws_iam_group" "group" {
  name = var.group.name
  path = var.group.path
}

resource "aws_iam_group_policy_attachment" "policy_attachments" {
  for_each   = toset(var.group.policies)
  group      = aws_iam_group.group.name
  policy_arn = each.value

  depends_on = [
    aws_iam_group.group,
  ]
}
