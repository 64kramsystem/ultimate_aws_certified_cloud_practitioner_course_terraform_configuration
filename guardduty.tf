# Deleting will disable the service and destroy the findings; alternatively, one case set `enable`
# to `false`.
#
resource "aws_guardduty_detector" "eu-central-1" {
  enable = true
}

# This role is automatically created. It can't be modified, or attached via TF, so it's here for
# reference.
# Also, in the console, it's defined via list of actions+resource instead of assume_role+principal.
#
# resource "aws_iam_role" "guardduty" {
#   name = "AWSServiceRoleForAmazonGuardDuty"
#   path = "/aws-service-role/guardduty.amazonaws.com/"
#
#   description = "A service-linked role required for Amazon GuardDuty to access your resources. "
#
#   assume_role_policy = <<-JSON
#     {
#         "Version": "2012-10-17",
#         "Statement": [
#             {
#                 "Effect": "Allow",
#                 "Action": [
#                   "sts:AssumeRole"
#                 ],
#                 "Principal": {
#                     "Service": "guardduty.amazonaws.com"
#                 }
#             }
#         ]
#     }
#   JSON
# }
