################################################################################
# EBS VOLUMES
################################################################################

# See notes in the attachments section.
#
resource "aws_ebs_volume" "first_instance_extra" {
  availability_zone = aws_instance.first_instance.availability_zone
  size              = 2
  encrypted         = true
  kms_key_id        = aws_kms_key.ebs-test.arn
}

################################################################################
# EBS VOLUME ATTACHMENTS
################################################################################

# There are important gotchas when working with volumes:
#
# - root volumes are tied to the EC2 instance lifecycle;
# - importing partition attachments (like root volumes) requires the partition device, which is
#   invalid for creation;
# - a range of `/dev/sdN` devices can't be used (see https://git.io/JJlmj).
#
# import aws_volume_attachment.first_instance_extra /dev/sdx:vol-07c125e8448982388:i-0bd4d93a03d020239
#
resource "aws_volume_attachment" "first_instance_extra" {
  device_name = "/dev/sdx"
  volume_id   = aws_ebs_volume.first_instance_extra.id
  instance_id = aws_instance.first_instance.id
}

################################################################################
# EBS SNAPSHOTS
################################################################################

resource "aws_ebs_snapshot" "first_instance_extra" {
  volume_id = aws_ebs_volume.first_instance_extra.id
}
