resource "aws_cloudwatch_metric_alarm" "ec2_first_instance_cpu_utilization_alarm" {
  alarm_name = "EC2_First_Instance_CPUUtilizationAlarm"

  metric_name = "CPUUtilization"

  namespace = "AWS/EC2"

  dimensions = {
    "InstanceId" = aws_instance.first_instance.id
  }

  # `GreaterThanOrEqualToThreshold`, etc.
  #
  comparison_operator = "GreaterThanThreshold"

  threshold = 80

  alarm_actions = [
    aws_sns_topic.system_alarms.arn,
  ]

  evaluation_periods  = 1
  datapoints_to_alarm = 1
  period              = 300
  statistic           = "Average"
}

# Created via EC2 instances Monitoring tab.
#
resource "aws_cloudwatch_metric_alarm" "ec2_first_instance_system_status_check_failed" {
  alarm_name = "EC2_First_Instance_System_Status_Check_Failed"

  metric_name = "StatusCheckFailed_System"

  namespace = "AWS/EC2"

  dimensions = {
    "InstanceId" = aws_instance.first_instance.id
  }

  comparison_operator = "GreaterThanOrEqualToThreshold"

  threshold = 1

  alarm_actions = [
    "arn:aws:automate:eu-central-1:ec2:recover", # Recover the instance
    aws_sns_topic.system_alarms.arn,
  ]

  evaluation_periods = 2
  period             = 60
  statistic          = "Maximum"
  treat_missing_data = "missing"

  # Interestingly, 0 is the default when created via Monitoring tab, which is invalid for TF, which
  # requires at least 1.
  #
  datapoints_to_alarm = 1

  alarm_description = "Created from EC2 Console"
}

# Special billing alarms - needs to be in `us-east-1`.
#
resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name = "BillingAlarm"
  provider   = aws.us-east-1

  metric_name = "EstimatedCharges"

  namespace = "AWS/Billing"

  dimensions = {
    "Currency" = "USD"
  }

  comparison_operator = "GreaterThanThreshold"

  threshold = 10

  alarm_actions = [
    aws_sns_topic.billing_alarms.arn,
  ]

  evaluation_periods = 1
  period             = 21600
  statistic          = "Maximum"
  treat_missing_data = "missing"

  # Interestingly, 0 is the default when created via Monitoring tab, which is invalid for TF, which
  # requires at least 1.
  #
  datapoints_to_alarm = 1
}

