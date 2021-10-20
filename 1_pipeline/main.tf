terraform {
  backend "s3" {
    bucket = "hands-on-cloud-terraform-remote-state-s3"
    key = "hands-on-cloud-terraform-demo-pipeline.tfstate"
    region = "us-west-2"
    encrypt = "true"
  }
}

locals {
  aws_region  = "us-west-2"
  prefix      = "${var.repository_name}-${var.listen_branch_name}-pipeline"
  ssm_prefix  = "/org/hands-on-cloud/terraform"
  common_tags = {
    Project         = local.prefix
    ManagedBy       = "Terraform"
  }
}

