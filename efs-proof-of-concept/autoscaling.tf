# autoscaling group with 1 desired instance in it
# which is the ec2 we want to rsync to

resource "aws_autoscaling_group" "rsync" {
  name                      = "rsync"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  vpc_zone_identifier       = local.subnet_ids
  target_group_arns         = [aws_lb_target_group.rsync_tcp_22.arn]

  launch_template {
    id = aws_launch_template.rsync.id

    version = "$Latest"
  }

  tag {
    key                 = "name"
    value               = "rsync"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}

resource "aws_launch_template" "rsync" {
  name_prefix = "rsync"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
      volume_type = "gp2"
      encrypted   = true
      kms_key_id  = local.ec2.kms_key_id
    }
  }

  metadata_options {
    http_endpoint = "enabled"
  }

  monitoring {
    enabled = true
  }

  image_id               = local.ec2.ami
  instance_type          = local.ec2.instance_type
  vpc_security_group_ids = [aws_security_group.ec2.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "rsync-target"
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm.name
  }

  user_data = filebase64("${path.module}/user-data-rsync-target-ec2.cloud")
}
