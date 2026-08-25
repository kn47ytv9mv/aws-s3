variable "bucket" {
  default = null
}

variable "block_public_acls" {
  default = true
}

variable "block_public_policy" {
  default = true
}

variable "ignore_public_acls" {
  default = true
}

variable "restrict_public_buckets" {
  default = true
}

variable "kms_master_key_id" {
  default = null
}

variable "sse_algorithm" {
  default = "aws:kms"
}

variable "bucket_key_enabled" {
  default = true
}

variable "versioning" {
  default = "enabled"
}
