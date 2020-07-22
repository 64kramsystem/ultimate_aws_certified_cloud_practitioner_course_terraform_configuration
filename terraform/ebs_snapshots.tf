resource "aws_ebs_snapshot" "first_instance_extra" {
  volume_id = aws_ebs_volume.first_instance_extra.id
}
