data "aws_caller_identity" "current" {}

data "aws_vpc" "my_vpc" {
  id = "vpc-00d2d93d8a14d021e"
}


# when using an alias the key_id needs to start with 'alias/'
data "aws_kms_key" "ebs" {
  key_id = "alias/aws/ebs"
}

data "aws_kms_key" "efs" {
  key_id = "alias/aws/elasticfilesystem"
}

data "aws_subnets" "my_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.my_vpc.id]
  }
}

locals {
  region     = "eu-central-1"
  account_id = data.aws_caller_identity.current.account_id
  vpc_id     = data.aws_vpc.my_vpc.id
  vpc_cidr   = data.aws_vpc.my_vpc.cidr_block
  subnet_ids = data.aws_subnets.my_subnets.ids

  ec2 = {
    instance_type = "t2.nano"
    ami           = "ami-0006ba1ba3732dd33" # AWS Linux 2
    kms_key_id = data.aws_kms_key.ebs.arn
  }

  efs = {
    kms_key_id = data.aws_kms_key.efs.arn
  }
}
