resource "aws_security_group" "efs" {
  name        = "efs"
  description = "Allow inbound traffic from specified security group ids"
  vpc_id      = var.vpc_id

  ingress = [{
    cidr_blocks      = []
    description      = "Allow inbound nfs traffic"
    security_groups  = var.allowed_security_group_ids
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    self             = false
  }]

  egress = [{
    cidr_blocks      = []
    description      = "Allow all return traffic."
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = var.allowed_security_group_ids
    self             = false
    to_port          = 0
  }]
}
