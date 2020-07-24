resource "aws_instance" "instance_london" {
  ami           = "ami-0fb673bc6ff8fc282"
  instance_type = "t2.micro"

  provider = aws.eu-west-2

  subnet_id = aws_subnet.main-london.id
  vpc_security_group_ids = [
    aws_security_group.main-london.id,
  ]
  associate_public_ip_address = true

  key_name = "myuser"

  user_data = file("${path.module}/ec2_instances_user_data.sh")
}
