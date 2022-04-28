# autoscaling group with 1 desired instance in it
# which is the ec2 we want to rsync to

resource "aws_autoscaling_group" "rsync" {
  name                      = "rsync"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  health_check_type         = "ELB"
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
  name_prefix            = "rsync"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
      volume_type = "gp2"
      encrypted = true
      kms_key_id = local.ec2.kms_key_id
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

  user_data = filebase64("${path.module}/user-data-rsync-target-ec2.cloud")
}

# network load balancer
resource "aws_lb" "internal_lb" {
  name               = "internal"
  internal           = true
  load_balancer_type = "network"
  subnets            = local.subnet_ids

  enable_deletion_protection = true

  tags = {
    Name = "internal-lb"
  }
}

# load balancer listener on port 22 (can be something else...)
resource "aws_lb_listener" "rsync_tcp_22" {
  load_balancer_arn = aws_lb.internal_lb.arn
  port              = "22"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rsync_tcp_22.arn
  }
}

# load balancer target group for our rsync EC2 instance
# the target is port 22
resource "aws_lb_target_group" "rsync_tcp_22" {
  name        = "rsync-tcp-22"
  port        = 22
  protocol    = "TCP"
  target_type = "ip"

  vpc_id            = local.vpc_id
  proxy_protocol_v2 = false

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    port                = "traffic-port"
    protocol            = "TCP"
    interval            = 30
  }
}

# security group to attach to our ec2s
resource "aws_security_group" "ec2" {
  name        = "ec2"
  description = "Allow inbound ssh traffic from the vpc"
  vpc_id      = local.vpc_id

  ingress = [{
    cidr_blocks      = [local.vpc_cidr]
    description      = "Allow ssh traffic"
    security_groups  = []
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    self             = true
  }]

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow all egress."
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
}

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

module "efs" {
  source = "../modules/efs"
  subnet_ids = local.subnet_ids
  vpc_id = local.vpc_id
  kms_key_id = ""
}