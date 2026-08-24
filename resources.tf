resource "aws_s3_bucket_versioning" "resource" {
  bucket = aws_s3_bucket.resource.id

  versioning_configuration {
    status = title(lower(var.versioning))
  }
}

resource "aws_s3_bucket" "resource" {
  bucket = random_uuid.resource.id

  tags = var.tags
}

resource "random_uuid" "resource" {

}

