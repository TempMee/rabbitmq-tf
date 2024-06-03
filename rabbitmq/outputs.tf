output "broker_id" {
  value = aws_mq_broker.main.id
}

output "broker_arn" {
  value = aws_mq_broker.main.arn
}

output "broker_endpoint" {
  value = aws_mq_broker.main.instances.0.endpoints.0
}
