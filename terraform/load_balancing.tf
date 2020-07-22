# import ref.: arn
#
resource "aws_lb" "lb" {
  name               = "lb"
  internal           = false         # defaults to false
  load_balancer_type = "application" # "application" (default)  or "network"
  security_groups    = [aws_security_group.main.id]
  subnets = [
    aws_subnet.main.id,
    aws_subnet.main2.id,
  ]
}

# import ref: arn
#
resource "aws_lb_target_group" "lb-tg" {
  name     = "lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Can't be imported! When creating, existing matching ones will be replaced.
#
resource "aws_lb_target_group_attachment" "first_instance" {
  target_group_arn = aws_lb_target_group.lb-tg.arn
  target_id        = aws_instance.first_instance.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "second_instance" {
  target_group_arn = aws_lb_target_group.lb-tg.arn
  target_id        = aws_instance.second_instance.id
  port             = 80
}
