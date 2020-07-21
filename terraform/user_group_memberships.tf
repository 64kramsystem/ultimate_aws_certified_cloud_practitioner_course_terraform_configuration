resource "aws_iam_user_group_membership" "myuser" {
  user = aws_iam_user.myuser.name

  groups = [
    aws_iam_group.admins.name
  ]
}
