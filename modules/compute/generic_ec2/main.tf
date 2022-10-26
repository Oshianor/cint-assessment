# FIXME: All the modules are clubbed together currently to provide an MVP version to unblock
#        as module composition was failing badly and needs to get worked upon once the monolitic MVP works.

data "template_file" "user_script" {

  template = file("script.tpl")

}

/*# <START of SG functionality>
###################################
# Ingress - List of rules (simple)
###################################
# Security group rules with "cidr_blocks" and it uses list of rules names
resource "aws_security_group_rule" "ingress_rules" {
  count = length(var.ingress_rules)

  security_group_id = var.security_group
  type              = "ingress"

  cidr_blocks = var.ingress_cidr_blocks

  from_port   = var.ingress_rules[count.index]["from_port"]
  to_port     = var.ingress_rules[count.index]["to_port"]
  protocol    = var.ingress_rules[count.index]["protocol"]
  self        = var.ingress_rules[count.index]["self"]
  description = var.ingress_rules[count.index]["description"]
}

##################################
# Egress - List of rules (simple)
##################################
# Security group rules with "cidr_blocks" and it uses list of rules names
resource "aws_security_group_rule" "egress_rules" {
  count = length(var.egress_rules)

  security_group_id = var.security_group
  type              = "egress"

  cidr_blocks = var.egress_cidr_blocks

  from_port   = var.egress_rules[count.index]["from_port"]
  to_port     = var.egress_rules[count.index]["to_port"]
  protocol    = var.egress_rules[count.index]["protocol"]
  description = var.egress_rules[count.index]["description"]
}*/
# <END of SG functionality>

# <START of ASG functionality>
locals {
  default_tags_deprecated = length(data.aws_default_tags.tags.tags) == 0 ? {
    "automation"     = "terragrunt",
    "environment"    = "missing",
    "productbilling" = "missing"
  } : {}
  tags = merge(
    local.default_tags_deprecated,
    var.tags
  )
  tags_key_value = [
    for k, v in merge(data.aws_default_tags.tags.tags, local.tags) : {
      key                 = k
      value               = v
      propagate_at_launch = true
    }
    if k != "Name"
  ]
}

data "aws_default_tags" "tags" {}

#######################
# Launch configuration
#######################
resource "aws_launch_template" "this" {
  #checkov:skip=CKV_AWS_79:metadata service should be secured

  count = var.create_lc ? 1 : 0

  name_prefix            = "${coalesce(var.lc_name, var.name)}-"
  image_id               = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group
  ebs_optimized          = var.ebs_optimized
  user_data              = base64encode(data.template_file.user_script.rendered)

  monitoring {
    enabled = var.enable_monitoring
  }

  placement {
    tenancy = var.placement_tenancy
  }

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name = block_device_mappings.value.device_name

      ebs {
        delete_on_termination = lookup(block_device_mappings.value, "delete_on_termination", null)
        encrypted             = lookup(block_device_mappings.value, "encrypted", null)
        kms_key_id            = var.kms_key_id
        iops                  = lookup(block_device_mappings.value, "iops", null)
        volume_size           = lookup(block_device_mappings.value, "volume_size", null)
        volume_type           = lookup(block_device_mappings.value, "volume_type", null)
      }
    }
  }

  dynamic "metadata_options" {
    for_each = var.imdsv2_enabled ? ["enable_tokens"] : []
    content {
      http_endpoint      = "enabled"
      http_tokens        = "required"
      http_protocol_ipv6 = "disabled"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(data.aws_default_tags.tags.tags, local.tags)
  }

  tag_specifications {
    resource_type = "volume"
    tags          = merge(data.aws_default_tags.tags.tags, local.tags)
  }

  tags = local.tags
}

####################
# Autoscaling group
####################
resource "aws_autoscaling_group" "this" {
  count = var.create_asg ? 1 : 0

  name_prefix = "${join(
    "-",
    compact(
      [
        coalesce(var.asg_name, var.name),
        var.recreate_asg_when_lc_changes ? element(concat(random_pet.asg_name.*.id, [""]), 0) : "",
      ],
    ),
  )}-"
  launch_template {
    name    = var.create_lc ? element(concat(aws_launch_template.this.*.name, [""]), 0) : var.launch_template
    version = "$Latest"
  }

  vpc_zone_identifier = var.vpc_zone_identifier
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity

  load_balancers            = var.load_balancers
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type

  min_elb_capacity          = var.min_elb_capacity
  wait_for_elb_capacity     = var.wait_for_elb_capacity
  default_cooldown          = var.default_cooldown
  force_delete              = var.force_delete
  termination_policies      = var.termination_policies
  suspended_processes       = var.suspended_processes
  placement_group           = var.placement_group
  enabled_metrics           = var.enabled_metrics
  metrics_granularity       = var.metrics_granularity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  protect_from_scale_in     = var.protect_from_scale_in
  max_instance_lifetime     = var.max_instance_lifetime

  tags = distinct(concat(
    [
      {
        "key"                 = "Name"
        "value"               = var.name
        "propagate_at_launch" = true
      },
    ],
    local.tags_key_value,
  ))

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      target_group_arns,
    ]
  }
}

resource "aws_autoscaling_attachment" "this-tg-attach" {
  count = (var.create_asg && var.create_lb) ? length(var.target_groups) : 0

  autoscaling_group_name = aws_autoscaling_group.this[0].id
  alb_target_group_arn   = aws_lb_target_group.main[count.index].arn

  depends_on = [aws_autoscaling_group.this, aws_lb_target_group.main]
}

resource "random_pet" "asg_name" {
  count = var.recreate_asg_when_lc_changes ? 1 : 0

  separator = "-"
  length    = 2

  keepers = {
    # Generate a new pet name each time we switch launch template
    lc_name = var.create_lc ? element(concat(aws_launch_template.this.*.name, [""]), 0) : var.launch_template
  }
}
# <END of ASG functionality>

# <START of LB functionality>
resource "aws_lb" "this" {
  count = var.create_lb ? 1 : 0

  name        = var.name
  name_prefix = var.name_prefix

  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  security_groups    = var.load_balancer_type != "application" ? [] : var.security_group
  subnets            = var.subnets

  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = var.enable_http2
  ip_address_type                  = var.ip_address_type
  drop_invalid_header_fields       = var.drop_invalid_header_fields

  # See notes in README (ref: https://github.com/terraform-providers/terraform-provider-aws/issues/7987)
  dynamic "access_logs" {
    #checkov:skip=CKV_AWS_91:access logs are enabled through variables
    for_each = length(keys(var.access_logs)) == 0 ? [] : [var.access_logs]

    content {
      enabled = lookup(access_logs.value, "enabled", lookup(access_logs.value, "bucket", null) != null)
      bucket  = lookup(access_logs.value, "bucket", null)
      prefix  = lookup(access_logs.value, "prefix", null)
    }
  }

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping

    content {
      subnet_id     = subnet_mapping.value.subnet_id
      allocation_id = lookup(subnet_mapping.value, "allocation_id", null)
    }
  }

  tags = merge(
    local.tags,
    {
      Name = var.name != null ? var.name : var.name_prefix
    },
  )

  timeouts {
    create = var.load_balancer_create_timeout
    update = var.load_balancer_update_timeout
    delete = var.load_balancer_delete_timeout
  }
}

resource "aws_lb_target_group" "main" {
  count = var.create_lb ? length(var.target_groups) : 0

  name        = lookup(var.target_groups[count.index], "name", null)
  name_prefix = lookup(var.target_groups[count.index], "name_prefix", null)

  vpc_id      = var.vpc_id
  port        = lookup(var.target_groups[count.index], "backend_port", null)
  protocol    = lookup(var.target_groups[count.index], "backend_protocol", null) != null ? upper(lookup(var.target_groups[count.index], "backend_protocol")) : null
  target_type = lookup(var.target_groups[count.index], "target_type", null)

  deregistration_delay               = lookup(var.target_groups[count.index], "deregistration_delay", null)
  slow_start                         = lookup(var.target_groups[count.index], "slow_start", null)
  proxy_protocol_v2                  = lookup(var.target_groups[count.index], "proxy_protocol_v2", false)
  lambda_multi_value_headers_enabled = lookup(var.target_groups[count.index], "lambda_multi_value_headers_enabled", false)

  dynamic "health_check" {
    for_each = length(keys(lookup(var.target_groups[count.index], "health_check", {}))) == 0 ? [] : [lookup(var.target_groups[count.index], "health_check", {})]

    content {
      enabled             = lookup(health_check.value, "enabled", null)
      interval            = lookup(health_check.value, "interval", null)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
      timeout             = lookup(health_check.value, "timeout", null)
      protocol            = lookup(health_check.value, "protocol", null)
      matcher             = lookup(health_check.value, "matcher", null)
    }
  }

  dynamic "stickiness" {
    for_each = length(keys(lookup(var.target_groups[count.index], "stickiness", {}))) == 0 ? [] : [lookup(var.target_groups[count.index], "stickiness", {})]

    content {
      enabled         = lookup(stickiness.value, "enabled", null)
      cookie_duration = lookup(stickiness.value, "cookie_duration", null)
      type            = lookup(stickiness.value, "type", null)
    }
  }

  tags = merge(
    local.tags,
    lookup(var.target_groups[count.index], "tags", {}),
    {
      "Name" = lookup(var.target_groups[count.index], "name", lookup(var.target_groups[count.index], "name_prefix", ""))
    },
  )

  depends_on = [aws_lb.this]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "frontend_http_tcp" {
  count = var.create_lb ? length(var.http_tcp_listeners) : 0

  load_balancer_arn = aws_lb.this[0].arn

  port     = var.http_tcp_listeners[count.index]["port"]
  protocol = var.http_tcp_listeners[count.index]["protocol"]

  dynamic "default_action" {
    for_each = length(keys(var.http_tcp_listeners[count.index])) == 0 ? [] : [var.http_tcp_listeners[count.index]]

    # Defaults to forward action if action_type not specified
    content {
      type             = lookup(default_action.value, "action_type", "forward")
      target_group_arn = contains([null, "", "forward"], lookup(default_action.value, "action_type", "")) ? aws_lb_target_group.main[lookup(default_action.value, "target_group_index", count.index)].id : null

      dynamic "redirect" {
        for_each = length(keys(lookup(default_action.value, "redirect", {}))) == 0 ? [] : [lookup(default_action.value, "redirect", {})]

        content {
          path = lookup(redirect.value, "path", null)
          host = lookup(redirect.value, "host", null)
          port = lookup(redirect.value, "port", null)
          #checkov:skip=CKV_AWS_2:protocol is provided through variables
          protocol    = lookup(redirect.value, "protocol", null)
          query       = lookup(redirect.value, "query", null)
          status_code = redirect.value["status_code"]
        }
      }

      dynamic "fixed_response" {
        for_each = length(keys(lookup(default_action.value, "fixed_response", {}))) == 0 ? [] : [lookup(default_action.value, "fixed_response", {})]

        content {
          content_type = fixed_response.value["content_type"]
          message_body = lookup(fixed_response.value, "message_body", null)
          status_code  = lookup(fixed_response.value, "status_code", null)
        }
      }
    }
  }
}
# <END of LB functionality>
