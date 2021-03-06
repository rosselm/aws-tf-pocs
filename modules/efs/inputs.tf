variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key"
  type        = string
}

variable "creation_token" {
  description = "A unique name (a maximum of 64 characters are allowed) used as reference when creating the Elastic File System to ensure idempotent file system creation. By default generated by Terraform"
  type        = string
  default     = null
}

variable "performance_mode" {
  description = "The file system performance mode. Can be either `generalPurpose` or `maxIO`"
  type        = string
  default     = "generalPurpose" # other allowed values are 'maxIO' 
}

variable "provisioned_throughput_in_mibps" {
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput_mode set to provisioned."
  type        = string
  default     = null
}

variable "throughput_mode" {
  description = "Throughput mode for the file system. Valid values: bursting, provisioned. When using provisioned, also set provisioned_throughput_in_mibps."
  type        = string
  default     = "bursting"
}

variable "allowed_security_group_ids" {
  description = "Source/target security groups that are allowed to interact with the efs."
  type        = list(string)
  default     = []
}
