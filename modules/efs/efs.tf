resource "aws_efs_file_system" "proof_of_concept" {
  # see: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system

  creation_token                  = var.creation_token
  performance_mode                = var.performance_mode
  throughput_mode                 = var.throughput_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  encrypted                       = true
  kms_key_id                      = var.kms_key_id

  tags = {
    Name = "proof-of-concept"
  }
}

resource "aws_efs_mount_target" "proof_of_concept" {
  # bind the efs to multiple subnet ids (which can be in multiple AZs)
  for_each        = toset(var.subnet_ids)
  file_system_id  = aws_efs_file_system.proof_of_concept.id
  subnet_id       = each.key
  security_groups = [aws_security_group.efs.id]
}
