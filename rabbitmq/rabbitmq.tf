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
  security_groups            = var.security_group_ids
  publicly_accessible        = false
  auto_minor_version_upgrade = true
  deployment_mode            = var.type == "single-node" ? "SINGLE_INSTANCE" : "CLUSTER_MULTI_AZ"

  subnet_ids = var.type == "single-node" ? [var.subnet_ids[0]] : var.subnet_ids
  user {
    username = var.username
    password = var.password
  }

  tags = merge(var.tags, {
    Terraform = "true"
  })
}

#tfsec:ignore:aws-mq-enable-general-logging
#tfsec:ignore:aws-mq-enable-audit-logging
resource "aws_mq_broker" "node" {
  count = var.type == "single-node" ? 0 : var.nodes
  #checkov:skip=CKV_AWS_208: Already latest
  #checkov:skip=CKV_AWS_209: no need for encryption
  #checkov:skip=CKV_AWS_48: no need for logging
  apply_immediately = true
  broker_name       = "${var.name}-node-${count.index}"

  configuration {
    id = aws_mq_configuration.main.id
  }

  engine_type                = "RabbitMQ"
  engine_version             = "3.12.13"
  storage_type               = "ebs"
  host_instance_type         = var.instance_size
  security_groups            = var.security_group_ids
  publicly_accessible        = false
  auto_minor_version_upgrade = true
  deployment_mode            = "CLUSTER_MULTI_AZ"

  data_replication_mode               = "CRDR"
  data_replication_primary_broker_arn = aws_mq_broker.main.arn

  subnet_ids = var.subnet_ids
  user {
    username = var.username
    password = var.password
  }

  tags = merge(var.tags, {
    Terraform = "true"
  })
}
