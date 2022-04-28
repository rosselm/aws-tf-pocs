terraform {
  required_providers {
    aws = {
      # version = 
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = local.region

  profile = "martin.rosselle"

  default_tags {
    tags = {
      Terraform = true
      Owner     = "Martin Rosselle"
      Project   = "POC"
    }
  }
}