# Workaround to avoid self-reference. See https://www.terraform.io/docs/providers/aws/r/cloudfront_origin_access_identity.html#using-with-cloudfront.
#
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {}

# In order to update/destroy the distribution, it needs to be disabled first, AND the operation
# needs to complete on the AWS side.
#
resource "aws_cloudfront_distribution" "sav-test" {
  # See the corresponding bucket policy.
  #
  origin {
    # Append the region to `s3`, in order to send requests to the (selected) closer regional
    # endpoint, in order to have a faster first propagation, e.g. `s3-eu-central-1`.
    #
    domain_name = "${aws_s3_bucket.sav-test-private.bucket}.s3.amazonaws.com"
    origin_id   = "S3-${aws_s3_bucket.sav-test-private.bucket}"

    s3_origin_config {
      # See resource-based workaround above
      #
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.sav-test-private.bucket}"

    forwarded_values {
      query_string = false # default

      cookies {
        forward = "none" # default
      }
    }

    viewer_protocol_policy = "allow-all"
    default_ttl            = 0 # Default: 86400
    max_ttl                = 0 # Default: 31536000
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
