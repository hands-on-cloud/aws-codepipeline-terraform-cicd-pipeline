
data "aws_caller_identity" "current_account" {
  # To retrieve the account ID -- needed for KMS key policy
}


data "aws_region" "current_region" {
  # To retrieve the current AWS region
}

##### Buildspecs #####
data "local_file" "buildspec" {
  filename = "${path.module}/buildspecs/buildspec.yml"
}

data "local_file" "checkov" {
  filename = "${path.module}/buildspecs/checkov.yml"
}


data "local_file" "infracost" {
  filename = "${path.module}/buildspecs/infracost.yml"
}

data "local_file" "opa" {
  filename = "${path.module}/buildspecs/opa.yml"
}

data "local_file" "terrascan" {
  filename = "${path.module}/buildspecs/terrascan.yml"
}

data "local_file" "terratest" {
  filename = "${path.module}/buildspecs/terratest.yml"
}

data "local_file" "tflint" {
  filename = "${path.module}/buildspecs/tflint.yml"
}
