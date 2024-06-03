resource "aws_security_group" "rabbitmq" {
  name        = "rabbitmq"
  description = "Allow inbound traffic on port 5672"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidrs
  }
}

resource "aws_mq_configuration" "main" {
  description    = "Main RabbitMQ configuration"
  name           = "rabbitmq-configuration"
  engine_type    = "RabbitMQ"
  engine_version = "3.12.13"

  data = <<DATA
# Default RabbitMQ delivery acknowledgement timeout is 30 minutes in milliseconds
consumer_timeout = 1800000
DATA
}


resource "aws_mq_broker" "main" {
  broker_name = var.name

  configuration {
    id       = aws_mq_configuration.main.id
    revision = aws_mq_configuration.main.latest_revision
  }

  engine_type         = "RabbitMQ"
  engine_version      = "3.12.13"
  storage_type        = "ebs"
  host_instance_type  = var.instance_size
  security_groups     = [aws_security_group.rabbitmq.id]
  publicly_accessible = false

  subnet_ids = [var.subnet_ids[0]]
  user {
    username = var.username
    password = var.password
  }

  tags = {
    Terraform = "true"
  }
}