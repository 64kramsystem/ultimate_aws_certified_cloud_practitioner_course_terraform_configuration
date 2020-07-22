resource "aws_launch_template" "asg-template" {
  name                   = "ASGTemplate"
  update_default_version = false # don't bother with versioning

  image_id      = "ami-079024c517d22af5b"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.main.id
  ]
  network_interfaces {
    associate_public_ip_address = true
  }

  key_name = "myuser"

  iam_instance_profile {
    name = aws_iam_role.demo_role.name
  }

  # Must be base64 (!).
  #
  user_data = filebase64("${path.module}/ec2_instances_user_data.sh")
}

resource "aws_autoscaling_group" "asg" {
  name                      = "DemoASG"
  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 4
  health_check_type         = "ELB"
  health_check_grace_period = 300
  launch_template {
    id      = aws_launch_template.asg-template.id
    version = "$Default" # or $Latest
  }
  vpc_zone_identifier = [
    aws_subnet.main.id,
    aws_subnet.main2.id,
  ]

  # TF will add the following, even if not specified (here and in the console).
  #
  force_delete              = false
  wait_for_capacity_timeout = "10m"
}
