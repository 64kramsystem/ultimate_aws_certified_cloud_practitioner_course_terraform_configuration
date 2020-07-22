# See notes in `ebs_volume_attachment`.
#
# import aws_ebs_volume.first_instance_extra vol-07c125e8448982388
#
resource "aws_ebs_volume" "first_instance_extra" {
  availability_zone = aws_instance.first_instance.availability_zone
  size              = 2
}
