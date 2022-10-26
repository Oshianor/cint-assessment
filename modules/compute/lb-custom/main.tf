resource "random_integer" "web_target_group_id" {
  min = 1
  max = 999

  keepers = {
    port                 = var.tg_port
    protocol             = var.tg_protocol
    vpc_id               = var.vpc_id
    healthcheck_protocol = var.healthcheck_protocol
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "target-group" {
  name             = var.tg_custom_name ? var.tg_name : format("%0.25s-tg-%03d", var.lb_name, random_integer.web_target_group_id.result)
  port             = var.tg_port
  protocol         = var.tg_protocol
  protocol_version = contains(["HTTP", "HTTPS"], var.tg_protocol) ? var.tg_protocol_version : null
  vpc_id           = var.vpc_id
  target_type      = var.tg_target_type
  # Only applicable for Application Load Balancer Target Groups
  load_balancing_algorithm_type = var.lb_type == "network" ? null : "round_robin"

  deregistration_delay = var.tg_deregistration_delay

  health_check {
    enabled           = var.healthcheck_enabled
    healthy_threshold = var.healthcheck_healthy_threshold
    interval          = var.healthcheck_interval
    # Applies to Application Load Balancers only (HTTP/HTTPS), not Network Load Balancers (TCP).
    matcher = var.lb_type == "network" ? null : var.healthcheck_matcher
    # Applies to HTTP/HTTPS probe protocol, not TCP.
    path     = var.healthcheck_protocol == "TCP" ? null : var.healthcheck_path
    port     = var.healthcheck_port
    protocol = var.healthcheck_protocol
    # Network Load Balancers, you cannot set a custom value, and the default is 10 seconds for TCP and HTTPS health checks and 6 seconds for HTTP health checks.
    timeout             = var.lb_type == "network" ? null : var.healthcheck_timeout
    unhealthy_threshold = var.healthcheck_unhealthy_threshold
  }

  dynamic "stickiness" {
    for_each = var.stickiness_enabled ? ["enable_stickiness"] : []
    content {
      type            = var.stickiness_type
      cookie_duration = var.stickiness_cookie_duration
      cookie_name     = var.stickiness_cookie_name
      enabled         = var.stickiness_enabled
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_autoscaling_attachment" "asg-attachment" {
  count = var.asg_attachment ? 1 : 0

  autoscaling_group_name = var.asg_name
  alb_target_group_arn   = aws_lb_target_group.target-group.arn
}

resource "aws_lb_target_group_attachment" "instance-attachment" {
  count = length(var.instances_to_attach)

  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = var.instances_to_attach[count.index]
  port             = var.instances_attachment_port
}

resource "aws_lb" "lb" {
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_http2                     = "true"
  idle_timeout                     = "60"
  internal                         = var.lb_internal
  ip_address_type                  = "ipv4"
  load_balancer_type               = var.lb_type
  name                             = var.lb_name
  security_groups                  = var.lb_security_groups
  subnets                          = var.lb_subnets

  access_logs {
    bucket  = var.lb_logs_bucket
    enabled = "false"
    prefix  = var.lb_type == "network" ? "nlb" : "alb"
  }

  tags = merge(
    {
      "Name" = var.lb_name,
    },
    var.tags
  )
}

resource "aws_lb_listener" "lb-listener" {
  count = var.https_redirect ? 1 : 0

  default_action {
    order = "1"
    type  = "redirect"
    redirect {
      port        = var.listener_port
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
}

resource "aws_lb_listener" "lb-listener-https" {
  load_balancer_arn = aws_lb.lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  ssl_policy      = contains(["HTTPS", "TLS"], var.listener_protocol) ? "ELBSecurityPolicy-2016-08" : null
  certificate_arn = contains(["HTTPS", "TLS"], var.listener_protocol) ? var.cert_arn : null

  default_action {
    order            = "1"
    target_group_arn = aws_lb_target_group.target-group.arn
    type             = "forward"
  }
}
