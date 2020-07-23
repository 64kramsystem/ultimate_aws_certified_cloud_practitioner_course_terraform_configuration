locals {
  base_bucket_name = "sav986" # used to avoid cycles
}

data "aws_canonical_user_id" "current" {}

################################################################################
# BUCKET/PROPERTIES/POLICIES
################################################################################

# https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
#
resource "aws_s3_bucket" "sav-test" {
  bucket = local.base_bucket_name

  # TF forces these.
  #
  acl           = "private"
  force_destroy = true # default: false

  versioning {
    enabled = true
  }

  # Endpoint: http://sav986.s3-website.eu-central-1.amazonaws.com.
  # See note in the index object!
  #
  website {
    index_document = "index.html"
  }

  logging {
    target_bucket = "${local.base_bucket_name}-logging"
    target_prefix = "log/"
  }

  lifecycle_rule {
    enabled = true # mandatory

    transition {
      # Classes: STANDARD, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, GLACIER, DEEP_ARCHIVE
      #
      storage_class = "INTELLIGENT_TIERING"
      # days          = 30
    }
  }
}

resource "aws_s3_bucket" "sav-test-logging" {
  bucket = "${aws_s3_bucket.sav-test.bucket}-logging"

  force_destroy = true

  versioning {
    enabled = true
  }

  # Bucket ACLs required for setting a bucket for logging. Such grants are automatically set by AWS
  # when setting up logging via console.
  # Canonical id info: https://docs.aws.amazon.com/general/latest/gr/acct-identifiers.html.
  #
  grant {
    permissions = [
      "READ_ACP",
      "WRITE",
    ]
    type = "Group"
    uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
  }
  grant {
    id = data.aws_canonical_user_id.current.id
    permissions = [
      "FULL_CONTROL",
    ]
    type = "CanonicalUser"
  }
}

resource "aws_s3_bucket_public_access_block" "sav-test" {
  bucket = aws_s3_bucket.sav-test.bucket

  # AWS defaults all to true
  #
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "sav-test-allow-get-objects" {
  bucket = aws_s3_bucket.sav-test.bucket

  # As of v0.12.28, TF doesn't correctly handle the resources:
  #
  #   aws_s3_bucket.sav-test: Creating...
  #   aws_s3_bucket.sav-test: Creation complete after 2s [id=sav986]
  #   aws_s3_bucket_policy.sav-test-allow-get-objects: Creating...
  #   [...]
  #   Error: Error putting S3 policy: OperationAborted: A conflicting conditional operation is currently in progress against this resource.
  #
  # see https://git.io/JJ8Tj.
  #
  depends_on = [aws_s3_bucket_public_access_block.sav-test]

  policy = <<-POLICY
    {
      "Id": "Policy1595497452733",
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "Stmt1595497451256",
          "Action": [
            "s3:GetObject"
          ],
          "Effect": "Allow",
          "Resource": "${aws_s3_bucket.sav-test.arn}/*",
          "Principal": "*"
        }
      ]
    }
  POLICY
}

################################################################################
# OBJECTS
################################################################################

resource "aws_s3_bucket_object" "coffee" {
  bucket = aws_s3_bucket.sav-test.bucket
  key    = "coffee.jpg"
  source = "s3/coffee.jpg"

  # This is the default.
  #
  # content_type = "binary/octet-stream"
}

# Important! Since this is the index, the `content_type` must be specified! Otherwise, the index
# will be downloaded instead of opened.
#
resource "aws_s3_bucket_object" "index" {
  bucket       = aws_s3_bucket.sav-test.bucket
  key          = "index.html"
  source       = "s3/index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "images-dir" {
  bucket = aws_s3_bucket.sav-test.bucket
  key    = "images/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "beach" {
  bucket = aws_s3_bucket.sav-test.bucket
  key    = "images/beach.jpg"
  source = "s3/images/beach.jpg"

  storage_class = "INTELLIGENT_TIERING"
}
