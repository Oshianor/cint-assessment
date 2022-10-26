
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

## FAQ

#### How would a future application obtain the load balancer’s DNS name if it wanted to use this service?

To obtain the dns from the ALB there are multiple ways either you go through the AWS portal or you run the below command on resource dir `terragrunt output lb_dns_name`
this should give the dns name.

#### What aspects need to be considered to make the code work in a CD pipeline (how does it successfully and safely get into production)?

There are couple of things we need to enable to get it to work.

Firstly we need to split up the repo for modules and our actually infra code. We can use a tagging methodology to deliver new modules `0.0.3` release

Secondly we need to setup a project directory with the eu-west-2 region called `prod` with identitical structure with the `rd` env structure.
Using assume role with can setup a jenkins job that is manually triggered after only a PR is approved my peers

We need lint checks like `terragrunt hclfmt` and unit test before a PR is approved.

After the PR is apporved then and only then should the new Infra be manually triggered.
