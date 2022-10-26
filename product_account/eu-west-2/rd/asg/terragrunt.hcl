locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals

  ami_id = local.env_vars.ami_id
  env    = local.env_vars.env
}

terraform {
  source = "../../../../modules/compute/asg"
}

# include {
#   path = find_in_parent_folders()
# }

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    public_subnets  = ["subnet-r65678u2gb"]
    private_subnets = ["subnet-r65678u2gb"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

# dependency "sg" {
#   config_path = "../sg"
#   mock_outputs = {
#     public_subnets  = ["subnet-r65678u2gb"]
#     private_subnets = ["subnet-r65678u2gb"]
#   }
#   mock_outputs_allowed_terraform_commands = ["validate", "plan"]
# }


inputs = {
  name = "nano-cint-${local.env}-asg"
  # security_group = 

  min_size                  = 2
  max_size                  = 2
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = dependency.vpc.outputs.private_subnets

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch template
  launch_template_name        = "cint-asg"
  launch_template_description = "Cint Launch template"
  update_default_version      = true

  image_id          = local.ami_id
  instance_type     = "t3.micro"
  ebs_optimized     = true
  enable_monitoring = true

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "iam-asg"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
      }, {
      device_name = "/dev/sda1"
      no_device   = 1
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 30
        volume_type           = "gp2"
      }
    }
  ]

  tags = {
    component      = "compute"
    env            = "rd"
    productbilling = "cint"
    team           = "devops"
    terraform      = true
  }
}
