resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  # From the console, AWS forces this.
  #
  tags = {
    Name = "gateway"
  }
}

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
