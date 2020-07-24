terraform {
  required_version = "0.12.28"
}

provider "aws" {
  region     = var.aws_default_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

provider "aws" {
  alias      = "eu-west-2"
  region     = "eu-west-2" # London
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

# Conveniences for referencing the region.

data "aws_region" "eu-central-1" {
  provider = aws
}

data "aws_region" "eu-west-2" {
  provider = aws.eu-west-2
}
