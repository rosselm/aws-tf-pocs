resource "aws_lb" "internal_lb" {
  name               = "internal"
  internal           = true
  load_balancer_type = "network"
  subnets            = local.subnet_ids

  enable_deletion_protection = false

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
  target_type = "instance"

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