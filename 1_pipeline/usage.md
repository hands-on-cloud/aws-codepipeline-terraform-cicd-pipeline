# AWS CodePipeline demo CICD pipeline for testing Terraform projects

This module deploys AWS CodePipeline, which uses tflint, Checkov, OPA, Terrascan, and Terratest to test Terraform modules.

Check out [How to use CodePipeline CICD pipeline to test Terraform](https://hands-on.cloud/how-to-use-codepipeline-cicd-pipeline-to-test-terraform/) article for more information.

![CICD pipeline architecture](img/CICD-pipeline-architecture.png)

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
