resource "aws_kms_key" "ebs-test" {}

locals {
  # These can be, for example, passed from the environment.
  #
  my_secret_values = {
    key1 = "value1",
    key2 = "value2",
  }
}

resource "aws_secretsmanager_secret" "my_secret" {
  name = "my_secret" # optional

  recovery_window_in_days = 30 # Default

  # Optional; if not specified, the account's default CMK is used.
  #
  # kms_key_id = "..."
}

resource "aws_secretsmanager_secret_version" "my_secret" {
  secret_id     = aws_secretsmanager_secret.my_secret.id
  secret_string = jsonencode(local.my_secret_values)
}
