
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

For this project, Since the addition was code was just a VPC setup,

```bash
  npm install my-project
  cd my-project
```
