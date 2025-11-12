# CloudWatch → Opsgenie Automation

1️⃣ Tag EC2s you want monitored:
   Key = Monitor
   Value = Enabled

2️⃣ Run Terraform
```bash
terraform init
terraform apply \
  -var 'region=ap-south-1' \
  -var 'opsgenie_endpoint_url=https://api.opsgenie.com/v1/json/cloudwatch?apiKey=YOURKEY' \
  -var 'paths=["/","/data"]'
