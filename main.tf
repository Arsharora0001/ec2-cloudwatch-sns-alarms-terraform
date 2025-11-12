terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.50"
    }
  }
}

provider "aws" {
  region = var.region
}

# SNS topic for Opsgenie alerts
# SNS topic for alerts (unchanged)
resource "aws_sns_topic" "opsgenie" {
  name = var.sns_topic_name
}

# Replace HTTPS subscription with EMAIL
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.opsgenie.arn
  protocol  = "email" # or "email-json" for JSON body
  endpoint  = var.alert_email
}
