# IAM

resource "aws_iam_role" "codebuild" {
  description = "CodeBuild Service Role - Managed by Terraform"
  tags        = local.common_tags

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "codebuild.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "codebuild" {
  role = aws_iam_role.codebuild.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:*"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:DeleteItem"
          ],
          "Resource" : data.aws_ssm_parameter.locks_table_arn.value
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "kms:*"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:*"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

# CodeBuild
resource "aws_codebuild_project" "tflint" {
  #checkov:skip=CKV_AWS_147: "temp"

  name         = "${var.project_name}-tflint"
  description  = "Managed using Terraform"
  service_role = aws_iam_role.codebuild.arn
  tags         = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:6.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.local_file.tflint.content
  }
}

resource "aws_codebuild_project" "checkov" {
  #checkov:skip=CKV_AWS_147: "temp"

  name         = "${var.project_name}-checkov"
  description  = "Managed using Terraform"
  service_role = aws_iam_role.codebuild.arn
  tags         = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_MEDIUM"
    image        = "aws/codebuild/standard:6.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.local_file.checkov.content
  }
}

resource "aws_codebuild_project" "opa" {
  #checkov:skip=CKV_AWS_147: "temp"

  name         = "${var.project_name}-opa"
  description  = "Managed using Terraform"
  service_role = aws_iam_role.codebuild.arn
  tags         = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:6.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.local_file.opa.content
  }
}

resource "aws_codebuild_project" "terrascan" {
  #checkov:skip=CKV_AWS_147: "temp"

  name         = "${var.project_name}-terrascan"
  description  = "Managed using Terraform"
  service_role = aws_iam_role.codebuild.arn
  tags         = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:6.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.local_file.terrascan.content
  }
}

resource "aws_codebuild_project" "terratest" {
  #checkov:skip=CKV_AWS_147: "temp"

  name         = "${var.project_name}-terratest"
  description  = "Managed using Terraform"
  service_role = aws_iam_role.codebuild.arn
  tags         = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:6.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.local_file.terratest.content
  }
}

resource "aws_codebuild_project" "infracost" {
  #checkov:skip=CKV_AWS_147: "temp"

  name         = "${var.project_name}-infracost"
  description  = "Managed using Terraform"
  service_role = aws_iam_role.codebuild.arn
  tags         = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:6.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "INFRACOST_API_KEY_SSM_PARAM_NAME"
      value = "${local.ssm_prefix}/infracost_api_key"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.local_file.infracost.content
  }
}

resource "aws_codebuild_project" "tf_apply" {
  #checkov:skip=CKV_AWS_147: "temp"

  name         = "${var.project_name}-tf-apply"
  description  = "Managed using Terraform"
  service_role = aws_iam_role.codebuild.arn
  tags         = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:6.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.local_file.buildspec.content
  }
}
