


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
