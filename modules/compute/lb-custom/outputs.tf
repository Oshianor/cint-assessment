output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}

output "lb_target_grp_arn" {
  value = aws_lb_target_group.target-group.arn
}

output "lb_target_grp_id" {
  value = aws_lb_target_group.target-group.id
}

output "lb_lb_dns_name" {
  value = aws_lb.lb.dns_name
}

output "lb_lb_zone_id" {
  value = aws_lb.lb.zone_id
}
