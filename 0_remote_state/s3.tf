resource "aws_s3_bucket" "remote_state" {
  #checkov:skip=CKV_AWS_144: "Cross Region Unneccessary"
  #checkov:skip=CKV_AWS_145: "Bucket Encryption IS enabled separately"

  bucket        = "${local.prefix}-${data.aws_caller_identity.current_account.id}"
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }

  tags = local.common_tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "remote_state" {
  bucket = aws_s3_bucket.remote_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_versioning" "remote_state_versioning" {
  bucket = aws_s3_bucket.remote_state.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_acl" "remote_state_acl" {
  bucket = aws_s3_bucket.remote_state.id
  acl    = "private"
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
  #checkov:skip=CKV2_AWS_34: "unneccessary for table arn"
  name  = "${local.ssm_prefix}/tf-remote-state-bucket"
  type  = "String"
  value = aws_s3_bucket.remote_state.id
  tags  = local.common_tags
}
