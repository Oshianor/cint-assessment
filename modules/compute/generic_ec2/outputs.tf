# FIXME: All the modules outouts are clubbed together currently to provide an MVP version to unblock
#        as module composition was failing badly and needs to get worked upon once the monolitic MVP works.

# <START of SG outputs>
output "security_group" {
  description = "The security group ID"
  value       = var.security_group
}

//output "this_security_group_ingress" {
//  description = "The ingress rules"
//  value       = "${element(concat(aws_security_group.this.*.ingress, list("")), 0)}"
//}
//output "this_security_group_egress" {
//  description = "The egress rules"
//    value       = "${element(concat(aws_security_group.this.*.egress, list("")), 0)"
//}
# <END of SG outputs>

# <START of ASG outputs>
locals {
  this_launch_template_id   = var.launch_template == "" && var.create_lc ? concat(aws_launch_template.this.*.id, [""])[0] : var.launch_template
  this_launch_template_name = var.launch_template == "" && var.create_lc ? concat(aws_launch_template.this.*.name, [""])[0] : ""

  this_autoscaling_group_id                        = concat(aws_autoscaling_group.this.*.id, [""])[0]
  this_autoscaling_group_name                      = concat(aws_autoscaling_group.this.*.name, [""])[0]
  this_autoscaling_group_arn                       = concat(aws_autoscaling_group.this.*.arn, [""])[0]
  this_autoscaling_group_min_size                  = concat(aws_autoscaling_group.this.*.min_size, [""])[0]
  this_autoscaling_group_max_size                  = concat(aws_autoscaling_group.this.*.max_size, [""])[0]
  this_autoscaling_group_desired_capacity          = concat(aws_autoscaling_group.this.*.desired_capacity, [""])[0]
  this_autoscaling_group_default_cooldown          = concat(aws_autoscaling_group.this.*.default_cooldown, [""])[0]
  this_autoscaling_group_health_check_grace_period = concat(aws_autoscaling_group.this.*.health_check_grace_period, [""])[0]
  this_autoscaling_group_health_check_type         = concat(aws_autoscaling_group.this.*.health_check_type, [""])[0]
  this_autoscaling_group_availability_zones        = concat(aws_autoscaling_group.this.*.availability_zones, [""])[0]
  this_autoscaling_group_vpc_zone_identifier       = concat(aws_autoscaling_group.this.*.vpc_zone_identifier, [""])[0]
  this_autoscaling_group_load_balancers            = concat(aws_autoscaling_group.this.*.load_balancers, [""])[0]
  this_autoscaling_group_target_group_arns         = concat(aws_autoscaling_group.this.*.target_group_arns, [""])[0]
}

output "this_launch_template_id" {
  description = "The ID of the launch template"
  value       = local.this_launch_template_id
}

output "this_launch_template_name" {
  description = "The name of the launch template"
  value       = local.this_launch_template_name
}

output "this_autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = local.this_autoscaling_group_id
}

output "this_autoscaling_group_name" {
  description = "The autoscaling group name"
  value       = local.this_autoscaling_group_name
}

output "this_autoscaling_group_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = local.this_autoscaling_group_arn
}

output "this_autoscaling_group_min_size" {
  description = "The minimum size of the autoscale group"
  value       = local.this_autoscaling_group_min_size
}

output "this_autoscaling_group_max_size" {
  description = "The maximum size of the autoscale group"
  value       = local.this_autoscaling_group_max_size
}

output "this_autoscaling_group_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       = local.this_autoscaling_group_desired_capacity
}

output "this_autoscaling_group_default_cooldown" {
  description = "Time between a scaling activity and the succeeding scaling activity"
  value       = local.this_autoscaling_group_default_cooldown
}

output "this_autoscaling_group_health_check_grace_period" {
  description = "Time after instance comes into service before checking health"
  value       = local.this_autoscaling_group_health_check_grace_period
}

output "this_autoscaling_group_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done"
  value       = local.this_autoscaling_group_health_check_type
}

output "this_autoscaling_group_availability_zones" {
  description = "The availability zones of the autoscale group"
  value       = local.this_autoscaling_group_availability_zones
}

output "this_autoscaling_group_vpc_zone_identifier" {
  description = "The VPC zone identifier"
  value       = local.this_autoscaling_group_vpc_zone_identifier
}

output "this_autoscaling_group_load_balancers" {
  description = "The load balancer names associated with the autoscaling group"
  value       = local.this_autoscaling_group_load_balancers
}

output "this_autoscaling_group_target_group_arns" {
  description = "List of Target Group ARNs that apply to this AutoScaling Group"
  value       = local.this_autoscaling_group_target_group_arns
}
# <END of ASG outputs>

# <START of LB outputs>
output "this_lb_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = concat(aws_lb.this.*.id, [""])[0]
}

output "this_lb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = concat(aws_lb.this.*.arn, [""])[0]
}

output "this_lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = concat(aws_lb.this.*.dns_name, [""])[0]
}

output "this_lb_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch."
  value       = concat(aws_lb.this.*.arn_suffix, [""])[0]
}

output "this_lb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = concat(aws_lb.this.*.zone_id, [""])[0]
}

output "http_tcp_listener_arns" {
  description = "The ARN of the TCP and HTTP load balancer listeners created."
  value       = aws_lb_listener.frontend_http_tcp.*.arn
}

output "http_tcp_listener_ids" {
  description = "The IDs of the TCP and HTTP load balancer listeners created."
  value       = aws_lb_listener.frontend_http_tcp.*.id
}

output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = aws_lb_target_group.main.*.arn
}

output "target_group_arn_suffixes" {
  description = "ARN suffixes of our target groups - can be used with CloudWatch."
  value       = aws_lb_target_group.main.*.arn_suffix
}

output "target_group_names" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
  value       = aws_lb_target_group.main.*.name
}
# <END of LB outputs>
