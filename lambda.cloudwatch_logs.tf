# The resources below are automatically created when a Lambda function is created. The group is
# created on the first Lambda execution.

resource "aws_cloudwatch_log_group" "lambda_example_log_group" {
  name = "/aws/lambda/${aws_lambda_function.example.function_name}"
}

resource "aws_iam_role" "lambda_example_logging" {
  name = "example-role-gs9nbjka"
  path = "/service-role/"

  assume_role_policy = <<-JSON
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect":    "Allow",
                "Action":    "sts:AssumeRole",
                "Principal": {
                    "Service": "lambda.amazonaws.com"
                }
            }
        ]
    }
  JSON
}

resource "aws_iam_policy" "lambda_example_logging" {
  name = "AWSLambdaBasicExecutionRole-6d128aa8-189b-42d2-aa07-9bb2e622c1cd"
  path = "/service-role/"

  # On automatic creation, AWS also adds this permission:
  #
  #   {
  #       "Effect": "Allow",
  #       "Action": "logs:CreateLogGroup",
  #       "Resource": "arn:aws:logs:<region>:<account_number>:*"
  #   },
  #
  # which in this case is not needed, since the log group is created by TF.
  #
  policy = <<-JSON
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Resource": [
                    "${aws_cloudwatch_log_group.lambda_example_log_group.arn}"
                ]
            }
        ]
    }
  JSON
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_example_logging.name
  policy_arn = aws_iam_policy.lambda_example_logging.arn
}
