resource "aws_cloudwatch_event_rule" "execute_example_lambda_every_hour" {
  name = "ExecuteExampleLambdaEveryHour"

  # Cron format: `cron(0 20 * * ? *)`
  #
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "execute_lambda" {
  rule = aws_cloudwatch_event_rule.execute_example_lambda_every_hour.name
  arn  = aws_lambda_function.example.arn
}

resource "aws_cloudwatch_event_rule" "send_email_on_user_login" {
  name = "SendEmailOnUserLogin"

  event_pattern = <<-JSON
    {
        "detail-type": [
            "AWS Console Sign In via CloudTrail"
        ]
    }
  JSON

  # Other example: EC2 machine termination
  # `instance-id` is optional; can be multiple entries.
  #
  # event_pattern = <<-JSON
  #   {
  #       "source": [
  #           "aws.ec2"
  #       ],
  #       "detail-type": [
  #           "EC2 Instance State-change Notification"
  #       ],
  #       "detail": {
  #           "instance-id": [
  #               "i-1234"
  #           ],
  #           "state": [
  #               "terminated"
  #           ]
  #       }
  #   }
  # JSON
}

resource "aws_cloudwatch_event_target" "notify_on_login" {
  rule = aws_cloudwatch_event_rule.send_email_on_user_login.name
  arn  = aws_sns_topic.system_alarms.arn
}
