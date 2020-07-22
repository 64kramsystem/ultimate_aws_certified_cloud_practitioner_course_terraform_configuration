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
