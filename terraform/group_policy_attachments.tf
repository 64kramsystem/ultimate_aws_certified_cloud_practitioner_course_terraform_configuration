resource "aws_iam_group_policy_attachment" "admins-administrator" {
  group      = aws_iam_group.admins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
