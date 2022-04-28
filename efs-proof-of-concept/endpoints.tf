resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = local.vpc_id
  service_name      = "com.amazonaws.${local.region}.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.vpce.id
  ]

  subnet_ids          = local.subnet_ids
  private_dns_enabled = true

  tags = {
    "Name" = "ssm"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = local.vpc_id
  service_name      = "com.amazonaws.${local.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.vpce.id
  ]

  subnet_ids          = local.subnet_ids
  private_dns_enabled = true

  tags = {
    "Name" = "ssm-messages"
  }
}
