# import aws_security_group.main sg-04af697a259440dec

resource "aws_security_group" "main" {
  name        = "launch-wizard-1"
  description = "launch-wizard-1 created 2020-07-22T10:10:25.013+02:00"
  vpc_id      = aws_vpc.main.id
}

# import aws_security_group_rule.main sgrule-468176756
#
resource "aws_security_group_rule" "main" {
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.main.id
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "main-1" {
  ipv6_cidr_blocks = [
    "::/0",
  ]
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.main.id
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "main-2" {
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.main.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "main-3" {
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.main.id
  to_port           = 0
  type              = "egress"
}
