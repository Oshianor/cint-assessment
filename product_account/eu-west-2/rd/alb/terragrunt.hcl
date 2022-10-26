locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals

  ami_id = local.env_vars.ami_id
  env    = local.env_vars.env
}

terraform {
  source = "../../../../modules/compute/lb-custom"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id  = "vpc-r65678u2gb"
    private_subnets = ["subnet-r65678u2gb"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "asg" {
  config_path = "../asg"
  mock_outputs = {
    name = "cint-asg"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}


dependency "sg-alb" {
  config_path = "../sg/alb"
  mock_outputs = {
    name = "cint-asg"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}


inputs = {
  # General
  vpc_id                     = dependency.vpc.outputs.vpc_id
  enable_deletion_protection = "false"

  # LB
  lb_name            = "cint-rd-alb"
  lb_type            = "application"
  lb_internal        = false
  lb_subnets         = dependency.vpc.outputs.public_subnets
  # we could enable logging to s3 but this was deactivated for this test project
  # lb_logs_bucket     = local.lb_logs_bucket 
  lb_security_groups = [dependency.sg-alb.outputs.security_group_id]

  # Listener
  # cert_arn          = local.internal_certificate_arn
  listener_protocol = "HTTP"
  listener_port     = 80
  https_redirect    = false

  # Stickiness
  stickiness_enabled = "false"
  stickiness_type    = "lb_cookie"

  # ASG
  asg_attachment = true
  asg_name       = dependency.asg.outputs.autoscaling_group_name

  # TG
  tg_protocol = "HTTP"
  tg_port     = 80


  # HEALTHCHECK
  healthcheck_timeout             = 6
  healthcheck_healthy_threshold   = 3
  healthcheck_unhealthy_threshold = 3
  healthcheck_protocol            = "HTTP"
  healthcheck_port                = 80
  healthcheck_path                = "/api/v1/receive"
  healthcheck_matcher             = "200-499"

  tags = {
    component      = "compute"
    env            = "rd"
    productbilling = "cint"
    team           = "devops"
    terraform      = true
  }
}
