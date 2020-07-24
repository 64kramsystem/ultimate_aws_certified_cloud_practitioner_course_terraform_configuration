################################################################################
# VPCS
################################################################################

resource "aws_vpc" "main-london" {
  provider   = aws.eu-west-2
  cidr_block = "10.0.0.0/16"
}

################################################################################
# GATEWAY/ROUTES
################################################################################

resource "aws_internet_gateway" "igw-london" {
  provider = aws.eu-west-2
  vpc_id   = aws_vpc.main-london.id
}

resource "aws_route_table" "internet-london" {
  provider = aws.eu-west-2
  vpc_id   = aws_vpc.main-london.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-london.id
  }
}

resource "aws_main_route_table_association" "internet-london" {
  vpc_id         = aws_vpc.main-london.id
  route_table_id = aws_route_table.internet-london.id
}

################################################################################
# SUBNETS
################################################################################

resource "aws_subnet" "main-london" {
  provider   = aws.eu-west-2
  vpc_id     = aws_vpc.main-london.id
  cidr_block = "10.0.0.0/17"
}

################################################################################
# SECURITY GROUPS/RULES
################################################################################

resource "aws_security_group" "main-london" {
  name     = "main-london"
  provider = aws.eu-west-2
  vpc_id   = aws_vpc.main-london.id
}

resource "aws_security_group_rule" "main-london" {
  provider = aws.eu-west-2
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.main-london.id
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "main-london-2" {
  provider = aws.eu-west-2
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.main-london.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "main-london-3" {
  provider = aws.eu-west-2
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.main-london.id
  to_port           = 0
  type              = "egress"
}
