resource "random_uuid" "resource" {
  count = var.bucket == null ? 1 : 0
}

resource "aws_s3_bucket" "resource" {
  bucket        = coalesce(var.bucket, try(random_uuid.resource[0].id, null))
  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_versioning" "resource" {
  bucket = aws_s3_bucket.resource.id

  versioning_configuration {
    status = title(lower(var.versioning))
  }
}

resource "aws_s3_bucket_public_access_block" "resource" {
  bucket = aws_s3_bucket.resource.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_ownership_controls" "resource" {
  bucket = aws_s3_bucket.resource.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "resource" {
  bucket = aws_s3_bucket.resource.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_master_key_id
      sse_algorithm     = var.sse_algorithm
    }

    bucket_key_enabled = var.bucket_key_enabled
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "resource" {
  count = var.noncurrent_version_expiration_days == null ? 0 : 1

  bucket = aws_s3_bucket.resource.id

  rule {
    id     = "expire-noncurrent-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }
  }
}

data "aws_iam_policy_document" "deny_insecure_transport" {
  count = var.enforce_tls ? 1 : 0

  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.resource.arn,
      "${aws_s3_bucket.resource.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "resource" {
  count = var.enforce_tls ? 1 : 0

  bucket = aws_s3_bucket.resource.id
  policy = data.aws_iam_policy_document.deny_insecure_transport[0].json
}

output "arn" {
  value = aws_s3_bucket.resource.arn
}

output "bucket" {
  value = aws_s3_bucket.resource.id
}

output "bucket_domain_name" {
  value = aws_s3_bucket.resource.bucket_domain_name
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.resource.bucket_regional_domain_name
}
