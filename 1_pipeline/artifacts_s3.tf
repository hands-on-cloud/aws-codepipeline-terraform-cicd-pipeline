resource "aws_s3_bucket" "artifacts" {
  #checkov:skip=CKV_AWS_144: "Cross Region Unneccessary"
  #checkov:skip=CKV_AWS_145: "Bucket Encryption IS enabled separately"

  bucket        = "${var.project_name}-s3"
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }

  tags = local.common_tags
}

resource "aws_s3_bucket_public_access_block" "s3Public_artifacts" {
  bucket                  = aws_s3_bucket.artifacts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



resource "aws_s3_bucket_logging" "example" {
  bucket        = aws_s3_bucket.artifacts.id
  target_bucket = var.logging_bucket
  target_prefix = "s3/${aws_s3_bucket.artifacts.id}/"
}


resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.artifacts.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.artifacts.id
  acl    = "private"
}


resource "aws_s3_bucket_logging" "artifacts" {
  bucket        = aws_s3_bucket.artifacts.id
  target_bucket = var.logging_bucket
  target_prefix = "s3/${aws_s3_bucket.artifacts.id}/"
}

resource "aws_s3_bucket_policy" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  policy = <<POLICY
{
    "Version": "2008-10-17",
    "Statement": [
        {
          "Sid": "DenyInsecureAccess",
          "Effect": "Deny",
          "Principal": "*",
          "Action": "s3:*",
          "Resource": [
            "${aws_s3_bucket.artifacts.arn}",
            "${aws_s3_bucket.artifacts.arn}/*"
          ],
          "Condition": {
            "Bool": {
              "aws:SecureTransport": "false"
            }
          }
        },
        {
          "Sid": "EnforceEncryption",
          "Effect": "Deny",
          "Principal": "*",
          "Action": "s3:PutObject",
          "Resource": [
            "${aws_s3_bucket.artifacts.arn}/*"
          ],
          "Condition": {
            "StringNotEquals": {
              "s3:x-amz-server-side-encryption": "AES256"
            }
          }
        }
    ]
}
POLICY

}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  depends_on              = [aws_s3_bucket_policy.artifacts]
  bucket                  = aws_s3_bucket.artifacts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
