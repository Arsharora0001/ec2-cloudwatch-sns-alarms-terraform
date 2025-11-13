########## Core ##########
variable "region" {
  description = "AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"
  validation {
    condition     = can(regex("^([a-z]{2}-[a-z]+-\\d)$", var.region))
    error_message = "Region must look like ap-south-1, us-east-1, etc."
  }
}

variable "sns_topic_name" {
  description = "SNS topic name for alarm notifications (email / Opsgenie)."
  type        = string
  default     = "opsgenie-alerts"
  validation {
    condition     = length(var.sns_topic_name) > 0
    error_message = "sns_topic_name cannot be empty."
  }
}

########## Target selection ##########
variable "target_tag_key" {
  description = "Tag key used to select EC2 instances (e.g., Monitor)."
  type        = string
  default     = "Monitor"
  validation {
    condition     = length(var.target_tag_key) > 0 && !can(regex("[:\\s]", var.target_tag_key))
    error_message = "target_tag_key must be a non-empty string without spaces or colons."
  }
}

variable "target_tag_value" {
  description = "Tag value used to select EC2 instances (e.g., Enabled)."
  type        = string
  default     = "Enabled"
  validation {
    condition     = length(var.target_tag_value) > 0
    error_message = "target_tag_value cannot be empty."
  }
}

########## Metrics & alarms ##########
variable "paths" {
  description = "Filesystem mount paths to create per-path disk alarms for."
  type        = list(string)
  default     = ["/", "/data"]
  validation {
    condition     = alltrue([for p in var.paths : can(regex("^/.*", p))])
    error_message = "Each path must start with '/'."
  }
}

# Low thresholds for testing (override in prod: 85/90/90)
variable "fs_usage_threshold" {
  description = "Disk used percent threshold for alarms (1-100)."
  type        = number
  default     = 5
  validation {
    condition     = var.fs_usage_threshold >= 1 && var.fs_usage_threshold <= 100
    error_message = "fs_usage_threshold must be between 1 and 100."
  }
}

variable "cpu_threshold" {
  description = "CPU utilization threshold (1-100)."
  type        = number
  default     = 1
  validation {
    condition     = var.cpu_threshold >= 1 && var.cpu_threshold <= 100
    error_message = "cpu_threshold must be between 1 and 100."
  }
}

variable "mem_threshold" {
  description = "Memory used percent threshold (1-100)."
  type        = number
  default     = 5
  validation {
    condition     = var.mem_threshold >= 1 && var.mem_threshold <= 100
    error_message = "mem_threshold must be between 1 and 100."
  }
}

########## Notification targets ##########
variable "alert_email" {
  description = "Email address to subscribe to the SNS topic for alarms."
  type        = string
  default     = "arsharora303@gmail.com"
  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.alert_email))
    error_message = "alert_email must be a valid email address."
  }
}

# Optional: Opsgenie (leave empty if not using)
variable "opsgenie_endpoint_url" {
  description = "Opsgenie HTTPS endpoint (leave empty to skip Opsgenie HTTPS subscription)."
  type        = string
  default     = ""
  validation {
    condition     = var.opsgenie_endpoint_url == "" || can(regex("^https://", var.opsgenie_endpoint_url))
    error_message = "If provided, opsgenie_endpoint_url must start with https://"
  }
}





