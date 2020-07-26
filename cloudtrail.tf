data "aws_caller_identity" "current" {}

locals {
  cloudtrail_bucket_name = "cloudtrail-demo-s999"
}

resource "aws_cloudtrail" "demo_trail" {
  name                       = "demo-trail"
  s3_bucket_name             = aws_s3_bucket.cloudtrail_demo.bucket
  is_multi_region_trail      = true
  enable_log_file_validation = true
}

resource "aws_s3_bucket" "cloudtrail_demo" {
  bucket = local.cloudtrail_bucket_name
}

resource "aws_s3_bucket_policy" "cloudtrail_demo" {
  bucket = aws_s3_bucket.cloudtrail_demo.bucket

  policy = <<-POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AWSCloudTrailAclCheck20150319",
                "Effect": "Allow",
                "Principal": {
                    "Service": "cloudtrail.amazonaws.com"
                },
                "Action": "s3:GetBucketAcl",
                "Resource": "arn:aws:s3:::${local.cloudtrail_bucket_name}"
            },
            {
                "Sid": "AWSCloudTrailWrite20150319",
                "Effect": "Allow",
                "Principal": {
                    "Service": "cloudtrail.amazonaws.com"
                },
                "Action": "s3:PutObject",
                "Resource": "arn:aws:s3:::${local.cloudtrail_bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
                "Condition": {
                    "StringEquals": {
                        "s3:x-amz-acl": "bucket-owner-full-control"
                    }
                }
            }
        ]
    }
  POLICY
}
