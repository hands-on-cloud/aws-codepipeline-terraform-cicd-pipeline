resource "aws_s3_bucket" "remote_state" {
  bucket = "${local.prefix}-s3"
  acl    = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = local.common_tags
}

resource "aws_s3_bucket_public_access_block" "s3Public_remote_state" {
  depends_on              = [aws_s3_bucket_policy.remote_state]
  bucket                  = aws_s3_bucket.remote_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "remote_state" {
  bucket = aws_s3_bucket.remote_state.id

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
            "${aws_s3_bucket.remote_state.arn}",
            "${aws_s3_bucket.remote_state.arn}/*"
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
            "${aws_s3_bucket.remote_state.arn}/*"
          ],
          "Condition": {
            "StringNotEquals": {
              "s3:x-amz-server-side-encryption": "AES256"
            }
          }
        },
        {
          "Sid": "DenyUnencryptedObjectUploads",
          "Effect": "Deny",
          "Principal": "*",
          "Action": "s3:PutObject",
          "Resource": [
            "${aws_s3_bucket.remote_state.arn}/*"
          ],
          "Condition": {
            "Null": {
              "s3:x-amz-server-side-encryption": "true"
            }
          }
        }
    ]
}
POLICY

}

resource "aws_ssm_parameter" "remote_state_bucket" {
  name  = "${local.ssm_prefix}/tf-remote-state-bucket"
  type  = "String"
  value = aws_s3_bucket.remote_state.id
  tags  = local.common_tags
}
