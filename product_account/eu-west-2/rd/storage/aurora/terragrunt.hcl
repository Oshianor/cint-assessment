locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env = local.env_vars.locals.env
}

terraform {
  source = "../../../../../modules/storage/aurora"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc"
  mock_outputs = {
    vpc_id = "vpc-234fu48j"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "sg-aurora" {
  config_path = "../../sg/rds"
  mock_outputs = {
    security_group_id = "sg-234fu48j"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}


inputs = {
  create_cluster = true

  name              = "rds-aurora-${local.env}-db-postgres"
  engine            = "aurora-postgresql"
  engine_version    = "13.7"
  engine_mode       = "provisioned"
  storage_encrypted = true

  instance_class = "db.serverless"
  instances = {
    one = {}
    two = {}
  }

  publicly_accessible     = false
  vpc_id                  = dependency.vpc.outputs.vpc_id
  subnets                 = dependency.vpc.outputs.private_subnets
  allowed_security_groups = [dependency.sg-aurora.outputs.security_group_id]
  allowed_cidr_blocks     = [dependency.vpc.outputs.vpc_cidr_block]
  # kms_key_id = local.env_vars.locals.kms_arn

  apply_immediately   = true
  skip_final_snapshot = true
  monitoring_interval = 60

  serverlessv2_scaling_configuration = {
    min_capacity = 1
    max_capacity = 2
  }

  create_db_cluster_parameter_group      = true
  db_cluster_parameter_group_name        = "aurora-${local.env}-postgres13-cluster-parameter-group"
  db_cluster_parameter_group_description = "aurora-${local.env}-postgres13-cluster-parameter-group"
  db_cluster_parameter_group_family      = "aurora-postgresql13"

  create_db_parameter_group      = true
  db_parameter_group_name        = "aurora-${local.env}-db-postgres13-parameter-group"
  db_parameter_group_description = "aurora-${local.env}-db-postgres13-parameter-group"
  db_parameter_group_family      = "aurora-postgresql13"

  # username/password
  master_username        = "cintusername"
  create_random_password = true
  random_password_length = 30

  tags = {
    component      = "compute"
    env            = local.env
    productbilling = "cint"
    team           = "devops"
    terraform      = true
  }
}
