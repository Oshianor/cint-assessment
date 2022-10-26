locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env = local.env_vars.locals.env
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
    vpc_cidr_block = "10.0.0.0/8"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}


inputs = {
  sg_name     = "RDS"
  description = "Managed by Terraform"
  vpc_id      = dependency.vpc.outputs.vpc_id

  rules = {
    rule1 = {
      description = "Database access"
      cidr_blocks = [dependency.vpc.outputs.vpc_cidr_block]
      protocol    = "tcp"
      from_port   = "5432"
      to_port     = "5432"
    }
  }

  tags = {
    Name           = "sg-${local.env}-rds"
    component      = "compute"
    env            = local.env
    productbilling = "redtech"
    team           = "devops"
    terraform      = true
  }
}
