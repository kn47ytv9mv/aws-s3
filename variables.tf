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

variable "sse_algorithm" {
  default = "aes256"
}

variable "versioning" {
  default = "enabled"
}

output "arn" {
  value = aws_s3_bucket.resource.arn
}

output "bucket" {
  value = aws_s3_bucket.resource.id
}

