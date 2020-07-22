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
