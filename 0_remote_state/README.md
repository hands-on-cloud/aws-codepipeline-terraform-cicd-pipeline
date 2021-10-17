<!-- BEGIN_TF_DOCS -->

# Terraform remote state

This module deploys AWS infrastructure to store Terraform remote state in S3 bucket and lock Terraform execution in DynamoDB table.

![Terraform remote state](img/Remote-state.png)

## Deployment

```sh
terraform init
terraform plan
terraform apply -auto-approve
```

## Tier down

```sh
terraform destroy -auto-approve
```
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.lock_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_s3_bucket.remote_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.remote_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.s3Public_remote_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_ssm_parameter.locks_table_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.remote_state_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb-lock-table"></a> [dynamodb-lock-table](#output\_dynamodb-lock-table) | DynamoDB table for Terraform execution locks |
| <a name="output_dynamodb-lock-table-ssm-parameter"></a> [dynamodb-lock-table-ssm-parameter](#output\_dynamodb-lock-table-ssm-parameter) | SSM parameter containing DynamoDB table for Terraform execution locks |
| <a name="output_s3-state-bucket"></a> [s3-state-bucket](#output\_s3-state-bucket) | S3 bucket for storing Terraform state |
| <a name="output_s3-state-bucket-ssm-parameter"></a> [s3-state-bucket-ssm-parameter](#output\_s3-state-bucket-ssm-parameter) | SSM parameter containing S3 bucket for storing Terraform state |

<!-- END_TF_DOCS -->