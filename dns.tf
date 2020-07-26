resource "aws_route53_zone" "demo" {
  name = "64kram.systems"

  # Forced by TF.
  #
  comment       = "Managed by Terraform"
  force_destroy = false
}

# Import ref.: <zone_id>_<name>_<type>_<set_identifier>; example: `000000000000000000000_www.domain.com_A_eu-central-1`
#
resource "aws_route53_record" "www-eu-central-1" {
  zone_id        = aws_route53_zone.demo.id
  name           = "www.64kram.systems"
  set_identifier = "eu-central-1"
  type           = "A"
  ttl            = "300" # default
  latency_routing_policy {
    region = "eu-central-1"
  }
  records = [
    aws_instance.first_instance.public_ip
  ]
}

resource "aws_route53_record" "www-eu-west-2" {
  zone_id        = aws_route53_zone.demo.id
  name           = "www.64kram.systems"
  set_identifier = "eu-west-2"
  type           = "A"
  ttl            = "300"
  latency_routing_policy {
    region = data.aws_region.eu-west-2.name
  }
  records = [
    aws_instance.instance_london.public_ip
  ]
}
