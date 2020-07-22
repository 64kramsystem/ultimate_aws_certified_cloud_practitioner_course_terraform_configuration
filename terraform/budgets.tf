resource "aws_budgets_budget" "global" {
  name              = "Monthly budget"
  limit_amount      = "10.0"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2020-07-01_00:00"
  time_period_end   = "2087-06-15_00:00"
  budget_type       = "COST"

  notification {
    comparison_operator = "GREATER_THAN"
    notification_type   = "ACTUAL"
    subscriber_email_addresses = [
      "aws-test-monthly-budget@mailinator.com",
    ]
    subscriber_sns_topic_arns = []
    threshold                 = 100
    threshold_type            = "PERCENTAGE"
  }

  notification {
    comparison_operator = "GREATER_THAN"
    notification_type   = "FORECASTED"
    subscriber_email_addresses = [
      "aws-test-monthly-budget@mailinator.com",
    ]
    subscriber_sns_topic_arns = []
    threshold                 = 80
    threshold_type            = "PERCENTAGE"
  }
}
