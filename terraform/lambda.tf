resource "aws_iam_role" "lambda-example" {
  name = "example-role-gs9nbjka"
  path = "/service-role/"

  force_detach_policies = true # convenient; default: false

  assume_role_policy = <<-JSON
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow"
        }
      ]
    }
  JSON
}

resource "aws_lambda_function" "example" {
  function_name = "example"
  role          = aws_iam_role.lambda-example.arn

  runtime          = "python3.7"
  filename         = "lambda/example.zip"
  handler          = "lambda_function.lambda_handler" # <file-name>.<method>
  source_code_hash = filebase64sha256("lambda/example.zip")

  # Optional params
  #
  timeout     = 3   # seconds
  memory_size = 128 # MB

  # Forced by TF
  #
  publish = false # default
}
