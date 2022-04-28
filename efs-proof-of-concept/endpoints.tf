resource "aws_vpc_endpoint" "ssm" {
  vpc_id = local.vpc_id
  service_name = "com.amazonaws.${local.region}.ssm"

  security_group_ids = [
    aws_security_group.vpce.id
  ]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id = local.vpc_id
  service_name = "com.amazonaws.${local.region}.ssmmessages"

  security_group_ids = [
    aws_security_group.vpce.id
  ]
}