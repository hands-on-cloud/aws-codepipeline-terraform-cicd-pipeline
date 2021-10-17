output "dynamodb-lock-table" {
    value = aws_dynamodb_table.lock_table.name
    description = "DynamoDB table for Terraform execution locks"
}

output "dynamodb-lock-table-ssm-parameter" {
    value = "${local.ssm_prefix}/tf-locks-table-arn"
    description = "SSM parameter containing DynamoDB table for Terraform execution locks"
}

output "s3-state-bucket" {
    value = aws_s3_bucket.remote_state.id
    description = "S3 bucket for storing Terraform state"
}

output "s3-state-bucket-ssm-parameter" {
    value = "${local.ssm_prefix}/tf-remote-state-bucket"
    description = "SSM parameter containing S3 bucket for storing Terraform state"
}
