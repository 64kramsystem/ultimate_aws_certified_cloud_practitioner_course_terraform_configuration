resource "aws_sns_topic" "system_alarms" {
  name = "SystemAlarms"
}

# Email subscriptions (`protocol = "email"`) are not supported (see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#protocols-supported).
#
# resource "aws_sns_topic_subscription" "system_alarms_email" {
#   topic_arn = aws_sns_topic.system_alarms.arn
#
#   protocol = "email"
#   endpoint = "test-aws-system-alarms@mailinator.com"
# }

# Email subscription resource is omitted (see commented resource above).
#
resource "aws_sns_topic" "billing_alarms" {
  name = "BillingAlarms"

  provider = aws.us-east-1
}
