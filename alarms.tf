# Find EC2s tagged as monitored
data "aws_instances" "targets" {
  filter {
    name   = "tag:${var.target_tag_key}"
    values = [var.target_tag_value]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

# Disk usage alarms per EC2 per mount path
locals {
  combinations = flatten([
    for id in data.aws_instances.targets.ids : [
      for p in var.paths : { instance_id = id, path = p }
    ]
  ])
}

resource "aws_cloudwatch_metric_alarm" "disk_usage_high" {
  for_each            = { for c in local.combinations : "${c.instance_id}:${c.path}" => c }
  alarm_name          = "disk-high-${replace(each.value.path, "/", "-")}-${each.value.instance_id}"
  namespace           = "CWAgent"
  metric_name         = "disk_used_percent"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 5
  threshold           = var.fs_usage_threshold
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    InstanceId = each.value.instance_id
    path       = each.value.path
  }

  alarm_description = "Disk usage > ${var.fs_usage_threshold}% for 5 min on ${each.value.instance_id}"
  alarm_actions     = [aws_sns_topic.opsgenie.arn]
}

# CPU utilization alarm per instance
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  for_each            = toset(data.aws_instances.targets.ids)
  alarm_name          = "cpu-high-${each.value}"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 5
  threshold           = var.cpu_threshold # e.g., 90
  comparison_operator = "GreaterThanThreshold"
  dimensions          = { InstanceId = each.value }
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.opsgenie.arn]
  ok_actions          = [aws_sns_topic.opsgenie.arn] # optional: notify on recovery
}

# Memory utilization via CWAgent
resource "aws_cloudwatch_metric_alarm" "mem_high" {
  for_each            = toset(data.aws_instances.targets.ids)
  alarm_name          = "mem-high-${each.value}"
  namespace           = "CWAgent"
  metric_name         = "mem_used_percent"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 5
  threshold           = 90 # adjust to your liking
  comparison_operator = "GreaterThanThreshold"
  dimensions          = { InstanceId = each.value }
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.opsgenie.arn]
  ok_actions          = [aws_sns_topic.opsgenie.arn]
}
