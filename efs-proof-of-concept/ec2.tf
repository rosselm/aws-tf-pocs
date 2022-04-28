
# a test EC2 to test rsync towards the rsync target EC2
resource "aws_instance" "rsync_source" {
  subnet_id       = local.subnet_ids[0]
  instance_type   = local.ec2.instance_type
  ami             = local.ec2.ami
  security_groups = [aws_security_group.ec2.id]
  tags = {
    Name = "rsync-source"
  }
}

# a test EC2 to mount the efs as read-only -> to verify the file sharing/sync
resource "aws_instance" "efs_nfs_share_readonly_test" {
  subnet_id       = local.subnet_ids[1]
  instance_type   = local.ec2.instance_type
  security_groups = [aws_security_group.ec2.id]
  ami             = local.ec2.ami
  tags = {
    Name = "efs-ro-test"
  }
}