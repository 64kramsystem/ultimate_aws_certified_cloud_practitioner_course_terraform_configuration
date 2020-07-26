################################################################################
# VPCS
################################################################################

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

################################################################################
# GATEWAY/ROUTES
################################################################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  # From the console, AWS forces this.
  #
  tags = {
    Name = "gateway"
  }
}

# There is an alternative route resource; the below is the inline version.
#
resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.main.id

  # Multiple routes can be defined.
  # The local route is implicit, and can't be specified.
  #
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_main_route_table_association" "internet" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.internet.id
}

################################################################################
# SUBNETS
################################################################################

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/17"
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "main2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.128.0/17"
  availability_zone = "eu-central-1b"
}

################################################################################
# SECURITY GROUPS/RULES
################################################################################

resource "aws_security_group" "main" {
  name        = "launch-wizard-1"
  description = "launch-wizard-1 created 2020-07-22T10:10:25.013+02:00"
  vpc_id      = aws_vpc.main.id
}

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
