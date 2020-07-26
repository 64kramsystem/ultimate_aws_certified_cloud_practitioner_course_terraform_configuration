resource "aws_lightsail_instance" "wordpress-test" {
  name              = "WordPress"
  availability_zone = "eu-central-1a"
  blueprint_id      = "wordpress"
  bundle_id         = "nano_2_0"

  # Default given by Lightsail (for this blueprint); the username is `bitnami`, and can't be set.
  #
  key_pair_name = "LightsailDefaultKeyPair"
}
