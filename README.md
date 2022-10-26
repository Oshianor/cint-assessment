
# CINT TERRAFORM ASSESSMENT

Using terraform with conjunction with terragrunt, automate the build of the following application in AWS. For the purposes of this
challenge, use any Linux based AMI id for the two EC2 instances and simply show how they would
be provisioned with the connection details for the RDS.

## Tech Stack

**Modules:** Terraform

**Infra:** Terragrunt

## Requirements

To run the following project you need Terraform and Terragrunt installed with AWS CLI setup. You can use the below link to setup a compatible versions between Terraform & Terragrunt.

[Terraform version manager tfenv](https://github.com/tfutils/tfenv)

[Terragrunt version manager tgenv](https://github.com/cunymatthieu/tgenv)

## Environment Variables

To run this project, you will need to add the following environment variables to your env file

#### Default

You can use the default setup for a single account which should work right the box with no additional configuration which is a recommended way for this assessment.

#### Assume Role

If you want to use assume role to deploy which is possible with the current project setup,
you'll need need to make so additional changes to the [account.hcl](https://github.com/Oshianor/cint-assessment/blob/main/product_account/account.hcl) file
 and after that you'll need to inset the profile and role arn to the remote state and provided block.
There are comments on the file to guide you on the requirement.

#### Configuration files

There are some configuration files that you pay attention to like

[terragrunt.hcl](https://github.com/Oshianor/cint-assessment/blob/main/terragrunt.hcl)

[account.hcl](https://github.com/Oshianor/cint-assessment/blob/main/product_account/account.hcl)

[region.hcl](https://github.com/Oshianor/cint-assessment/blob/main/product_account/eu-west-2/region.hcl)

[env.hcl](https://github.com/Oshianor/cint-assessment/blob/main/product_account/eu-west-2/rd/env.hcl)

## Documentation

There are new infra modules for every resources created from the VPC, ALB, ASG, RDS Aurora to SG.
 To run apply this project on AWS, some resources takes precedence due to dependency on other resources.
 However you can plan out the infra without any resources been deployed.
Below is the mapped out structure on how to apply the infra.

```bash
terragrunt run-all plan

cd cint-assessment/product_account/eu-west-2/rd/vpc
terragrunt apply -auto-approve

cd ../sg
terragrunt run-all apply -auto-approve

cd ../asg
terragrunt apply -auto-approve

cd ../alb
terragrunt apply -auto-approve

cd ../storage/aurora
terragrunt apply -auto-approve

```
