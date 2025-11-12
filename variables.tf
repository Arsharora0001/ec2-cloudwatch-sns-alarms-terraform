variable "region" { default = "ap-south-1" }

variable "opsgenie_endpoint_url" {
  description = "Opsgenie HTTPS endpoint from integration page"
  type        = string
  default     = "test"
}

variable "sns_topic_name" { default = "opsgenie-alerts" }

# Which EC2s to monitor (tag filter)
variable "target_tag_key" {
  default = "Monitor"
  type    = string
}
variable "target_tag_value" {
  default = "Enabled"
  type    = string
}

variable "paths" { default = ["/", "/data"] }
# variable "fs_usage_threshold" { default = 85 }
# variable "cpu_threshold" { default = 90 }
variable "fs_usage_threshold" { default = 5 }
variable "cpu_threshold"      { default = 1 }
variable "mem_threshold"      { default = 5 }

variable "alert_email" {
  description = "Email address to receive SNS alerts"
  type        = string
  default     = "arsharora303@gmail.com"
}

