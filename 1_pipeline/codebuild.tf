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
  name           = "${local.prefix}-tflint"
  description    = "Managed using Terraform"
  service_role   = aws_iam_role.codebuild.arn
  tags           = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec-tflint.yml"
  }
}

resource "aws_codebuild_project" "checkov" {
  name           = "${local.prefix}-checkov"
  description    = "Managed using Terraform"
  service_role   = aws_iam_role.codebuild.arn
  tags           = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec-checkov.yml"
  }
}

resource "aws_codebuild_project" "opa" {
  name           = "${local.prefix}-opa"
  description    = "Managed using Terraform"
  service_role   = aws_iam_role.codebuild.arn
  tags           = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec-opa.yml"
  }
}

resource "aws_codebuild_project" "terrascan" {
  name           = "${local.prefix}-terrascan"
  description    = "Managed using Terraform"
  service_role   = aws_iam_role.codebuild.arn
  tags           = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec-terrascan.yml"
  }
}

resource "aws_codebuild_project" "terratest" {
  name           = "${local.prefix}-terratest"
  description    = "Managed using Terraform"
  service_role   = aws_iam_role.codebuild.arn
  tags           = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec-terratest.yml"
  }
}

resource "aws_codebuild_project" "tf_apply" {
  name           = "${local.prefix}-tf-apply"
  description    = "Managed using Terraform"
  service_role   = aws_iam_role.codebuild.arn
  tags           = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}
