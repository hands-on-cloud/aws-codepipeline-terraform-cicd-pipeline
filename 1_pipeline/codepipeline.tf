# IAM

resource "aws_iam_role" "codepipeline" {
  description = "CodePipeline Service Role - Managed by Terraform"
  tags        = local.common_tags

  assume_role_policy = jsonencode(
  {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codepipeline.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  }
  )
}

resource "aws_iam_role_policy" "codepipeline" {
  role = aws_iam_role.codepipeline.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect":"Allow",
          "Action": [
            "s3:*"
          ],
          "Resource": "*"
        },
        {
          "Effect" : "Allow",
          "Action" : "iam:PassRole",
          "Resource" : aws_iam_role.codebuild.arn
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "codecommit:BatchGet*",
            "codecommit:BatchDescribe*",
            "codecommit:Describe*",
            "codecommit:Get*",
            "codecommit:List*",
            "codecommit:GitPull",
            "codecommit:UploadArchive",
            "codecommit:GetBranch",
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "codebuild:StartBuild",
            "codebuild:StopBuild",
            "codebuild:BatchGetBuilds"
          ],
          "Resource" : [
            aws_codebuild_project.tflint.arn,
            aws_codebuild_project.checkov.arn,
            aws_codebuild_project.opa.arn,
            aws_codebuild_project.terrascan.arn,
            aws_codebuild_project.terratest.arn,
            aws_codebuild_project.infracost.arn,
            aws_codebuild_project.tf_apply.arn
          ]
        }
      ]
    }
  )
}

# CodePipeline

resource "aws_codepipeline" "demo" {
  name     = "${local.prefix}-demo"
  role_arn = aws_iam_role.codepipeline.arn
  tags     = local.common_tags

  artifact_store {
    location = aws_s3_bucket.artifacts.id
    type     = "S3"
  }

  stage {
    name = "Clone"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["CodeWorkspace"]

      configuration = {
        RepositoryName       = var.repository_name
        BranchName           = var.listen_branch_name
        PollForSourceChanges = true
      }
    }
  }

  stage {
    name = "Terraform-Project-Testing"

    action {
      run_order        = 1
      name             = "tflint"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["CodeWorkspace"]
      output_artifacts = []
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.tflint.name
      }
    }

    action {
      run_order        = 1
      name             = "checkov"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["CodeWorkspace"]
      output_artifacts = []
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.checkov.name
      }
    }

    action {
      run_order        = 1
      name             = "opa"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["CodeWorkspace"]
      output_artifacts = []
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.opa.name
      }
    }

    action {
      run_order        = 1
      name             = "terrascan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["CodeWorkspace"]
      output_artifacts = []
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.terrascan.name
      }
    }

    action {
      run_order        = 2
      name             = "terratest"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["CodeWorkspace"]
      output_artifacts = []
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.terratest.name
      }
    }

    action {
      run_order        = 1
      name             = "infracost"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["CodeWorkspace"]
      output_artifacts = []
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.infracost.name
      }
    }
  }

  stage {
    name = "Manual-Approval"

    action {
      run_order = 1
      name      = "DevOps-Lead-Approval"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
    }
  }

  stage {
    name = "Deploy"

    action {
      run_order        = 1
      name             = "terraform-apply"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["CodeWorkspace"]
      output_artifacts = []
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.tf_apply.name
      }
    }
  }
}
