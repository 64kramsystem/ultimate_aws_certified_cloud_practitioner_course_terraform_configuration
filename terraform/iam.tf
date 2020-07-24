# The role/policy resources are in the related service configuration files (eg.
# `ec2_instances.tf`).

################################################################################
# GROUPS
################################################################################

resource "aws_iam_group" "admins" {
  name = "admins"
}

################################################################################
# GROUP POLICY ATTACHMENTS
################################################################################

resource "aws_iam_group_policy_attachment" "admins-administrator" {
  group      = aws_iam_group.admins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

################################################################################
# USERS
################################################################################

resource "aws_iam_user" "myuser" {
  name = "myuser"
}

# resource "aws_key_pair" "myuser" {
#   key_name   = "myuser"
#   public_key = "ssh-rsa [...] myuser"
# }

# resource "aws_key_pair" "myuser" {
#   key_name   = "myuser"
#   provider   = aws.eu-west-2
#   public_key = "ssh-rsa [...] myuser"
# }

################################################################################
# USER GROUP MEMBERSHIPS
################################################################################

resource "aws_iam_user_group_membership" "myuser" {
  user = aws_iam_user.myuser.name

  groups = [
    aws_iam_group.admins.name
  ]
}
