# How to use CodePipeline CICD pipeline to test Terraform

This is a demo Terraform repository to establish CodePipeline to test Terraform projects.

## Set up Terraform remote state infrastructure

This step is required to set up an infrastructure to store Terraform remote state files

```sh
cd 0_remote_state
terraform init
terraform plan
terraform apply -auto-approve
```
