################################################################################
# ROLES/POLICY ATTACHMENTS
################################################################################

resource "aws_iam_role" "demo_role" {
  name = "DemoRoleForEC2"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "demo-attach" {
  role       = aws_iam_role.demo_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

################################################################################
# INSTANCES
################################################################################

resource "aws_instance" "first_instance" {
  ami           = "ami-079024c517d22af5b"
  instance_type = "t2.micro"

  subnet_id = aws_subnet.main.id
  vpc_security_group_ids = [
    aws_security_group.main.id,
  ]
  associate_public_ip_address = true

  key_name = "myuser"

  iam_instance_profile = aws_iam_role.demo_role.id

  user_data = file("${path.module}/ec2_instances_user_data.sh")
}

resource "aws_instance" "second_instance" {
  ami           = "ami-079024c517d22af5b"
  instance_type = "t2.micro"

  subnet_id = aws_subnet.main2.id
  vpc_security_group_ids = [
    aws_security_group.main.id,
  ]
  associate_public_ip_address = true

  key_name = "myuser"

  iam_instance_profile = aws_iam_role.demo_role.id

  user_data = file("${path.module}/ec2_instances_user_data.sh")
}
