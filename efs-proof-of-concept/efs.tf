module "efs" {
  source         = "../modules/efs"
  subnet_ids     = local.subnet_ids
  vpc_id         = local.vpc_id
  kms_key_id     = local.efs.kms_key_id
  creation_token = "a-unique-efs-token-for-idempotency-purpose"
}