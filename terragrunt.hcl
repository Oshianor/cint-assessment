# "arn:aws:iam::${local.account_id}:role/${local.account_vars.iam_name_prefix}_${local.aws_profile}_role"

locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl")).locals

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals

  # Extract the variables we need for easy access
  aws_account_id = local.account_vars.aws_account_id
  aws_region     = local.region_vars.aws_region
  aws_profile    = local.account_vars.aws_profile
  company_name   = local.account_vars.company_name
  arn_role       = local.account_vars.arn_role

  default_tags = {
    # Mandatory tags
    component      = "missing"
    productbilling = "missing"
    team           = "missing"

    # Optional tags with defaults
    automation  = "terragrunt-default"
    environment = "${local.environment_vars.env}"

    # Not user managed tags
    tf_repo           = "terraform-infra-${local.environment_vars.env}"
    tf_stage          = "${local.environment_vars.env}"
    tf_component_path = "${path_relative_to_include()}"
  }

  tags = merge(
    local.default_tags,
    lookup(local.account_vars, "tags", {}),
    lookup(local.region_vars, "tags", {}),
    lookup(local.environment_vars, "tags", {}),
  )
}

inputs = merge(
  local.account_vars,
  local.region_vars,
  local.environment_vars,
  {
    tags = {}
  }
)

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket         = "${local.company_name}-terraform-${local.environment_vars.env}-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.aws_region}"
    encrypt        = true
    dynamodb_table = "terraform-rd-locks"

    # uncomment this block to use assume role
    # role_arn       = "${local.arn_role}"
    # profile        = "${local.aws_profile}"

  }
}


# stage/terragrunt.hcl
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = "${local.aws_region}"

  # uncomment this block to use assume role
  #profile = "${local.aws_profile}"
  #assume_role {
  # role_arn = "${local.arn_role}"
  #}

  default_tags {
    tags = ${jsonencode(local.tags)}
  }

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.aws_account_id}"]
}
EOF
}

# arn:aws:iam::898149372835:user/tf_rd_user
# shared_credentials_file = "~/.aws/credentials"

terraform {
  after_hook "show_plan" {
    commands = ["plan"]
    execute  = ["bash", "-c", "if [ -f terraform.plan ]; then terraform show -no-color terraform.plan > terraform_plan.hcl; fi"]
  }

  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=10m"]

  }

}
