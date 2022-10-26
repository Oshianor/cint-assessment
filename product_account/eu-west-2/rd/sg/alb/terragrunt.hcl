locals {
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

}

terraform {
  source = "../../../../../modules/compute/sec-grp"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc"
  mock_outputs = {
    vpc_id = "vpc-058d0b7203d550b8f"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}


inputs = {
  sg_name     = "LB-common"
  description = "Managed by Terraform"
  vpc_id      = dependency.vpc.outputs.vpc_id

  rules = {
    rule1 = {
      description = "HTTP"
      cidr_blocks = ["0.0.0.0/0"]
      protocol    = "tcp"
      from_port   = "80"
      to_port     = "80"
    }
  }
}
