variable "repository_name" {
  default = "tf-demo-project"
  description = "CodeCommit repository name for CodePipeline builds"
}

variable "listen_branch_name" {
  default = "master"
  description = "CodeCommit branch name for CodePipeline builds"
}
