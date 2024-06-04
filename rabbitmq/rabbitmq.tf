resource "aws_security_group" "rabbitmq" {
  name        = "rabbitmq"
  vpc_id      = var.vpc_id
  description = "Allow inbound traffic on port 5672 for RabbitMQ"

  ingress {
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidrs
    description = "Allow RabbitMQ traffic"
  }
}

resource "aws_mq_configuration" "main" {
  #checkov:skip=CKV_AWS_208: Already latest
  description    = "Main RabbitMQ configuration"
  name           = "rabbitmq-configuration"
  engine_type    = "RabbitMQ"
  engine_version = "3.12.13"

  data = <<DATA
# Default RabbitMQ delivery acknowledgement timeout is 30 minutes in milliseconds
consumer_timeout = 1800000
DATA
}

#tfsec:ignore:aws-mq-enable-general-logging
#tfsec:ignore:aws-mq-enable-audit-logging
resource "aws_mq_broker" "main" {
  #checkov:skip=CKV_AWS_208: Already latest
  #checkov:skip=CKV_AWS_209: no need for encryption
  #checkov:skip=CKV_AWS_48: no need for logging
  broker_name = var.name

  configuration {
    id = aws_mq_configuration.main.id
  }

  engine_type                = "RabbitMQ"
  engine_version             = "3.12.13"
  storage_type               = "ebs"
  host_instance_type         = var.instance_size
  security_groups            = [aws_security_group.rabbitmq.id]
  publicly_accessible        = false
  auto_minor_version_upgrade = true

  subnet_ids = [var.subnet_ids[0]]
  user {
    username = var.username
    password = var.password
  }

  tags = {
    Terraform = "true"
  }
}
