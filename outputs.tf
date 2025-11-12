output "sns_topic_arn" {
  value       = aws_sns_topic.opsgenie.arn
  description = "ARN of the SNS topic used for Opsgenie alerts"
}
