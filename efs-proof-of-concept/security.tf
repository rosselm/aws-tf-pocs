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

# instance profile for the ec2s - currently we only need ssm access
# to be able to shell into the instances
resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "ec2-ssm"
  role = aws_iam_role.ec2_ssm.name
}

resource "aws_iam_role" "ec2_ssm" {
  name = "ec2_ssm"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_security_group" "vpce" {
  name = "vpce"
  description = "Allow inbound https traffic from the vpc on interface vpc endpoint"
  vpc_id      = local.vpc_id

  ingress = [{
    cidr_blocks      = [local.vpc_cidr]
    description      = "Allow https traffic"
    security_groups  = []
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    from_port        = 443
    to_port          = 443
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