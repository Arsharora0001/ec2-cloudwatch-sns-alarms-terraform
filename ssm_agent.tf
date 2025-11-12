resource "aws_ssm_parameter" "cwagent_config" {
  name  = "/opsgenie/cwagent/config"
  type  = "String"
  value = file("${path.module}/cwagent_config.json")
}

resource "aws_ssm_association" "install_cwagent" {
  name = "AWS-ConfigureAWSPackage"
  targets {
    key    = "tag:${var.target_tag_key}" # becomes "tag:Monitor"
    values = [var.target_tag_value]      # ["Enabled"]
  }
  parameters = {
    action  = "Install"
    name    = "AmazonCloudWatchAgent"
    version = "latest"
  }
}

resource "aws_ssm_association" "configure_cwagent" {
  name = "AmazonCloudWatch-ManageAgent"
  targets {
    key    = "tag:${var.target_tag_key}" # becomes "tag:Monitor"
    values = [var.target_tag_value]      # ["Enabled"]
  }
  parameters = {
    action                        = "configure"
    mode                          = "ec2"
    optionalConfigurationLocation = aws_ssm_parameter.cwagent_config.name
    optionalConfigurationSource   = "ssm"
  }
}
