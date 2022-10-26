
# GENERAL
variable "vpc_id" {
  description = "VPC Identifier where TargetGroup will be created"
  type        = string
}
variable "enable_deletion_protection" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#enable_deletion_protection"
  type        = bool
  default     = false
}
variable "enable_cross_zone_load_balancing" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#enable_cross_zone_load_balancing"
  type        = bool
  default     = true
}
variable "tags" {
  description = "Map of tags to attach to all resources, most common keys: Name, component, environment, productbilling, team"
  type        = map(any)
  default     = {}
}

# LOAD BALANCER
variable "lb_name" {
  description = "LoadBalancer name. In TargetGroup name will be shortened to 25 characters"
  type        = string
}
variable "lb_type" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#load_balancer_type"
  type        = string
  default     = "network"
}
variable "lb_internal" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#internal"
  type        = bool
  default     = true
}
variable "lb_subnets" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#subnets"
  type        = list(any)
  default     = []
}
variable "lb_security_groups" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#security_groups"
  type        = list(any)
  default     = []
}
variable "lb_logs_bucket" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#bucket"
  type        = string
  default = ""
}

# LISTENER
variable "listener_protocol" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#protocol"
  type        = string
  default     = "HTTPS"
}
variable "listener_port" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#port"
  type        = number
  default     = 443
}
variable "cert_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#certificate_arn"
  type        = string
  default     = ""
}
variable "https_redirect" {
  description = "If true additional listener will be created for HTTP to HTTPS redirection"
  type        = bool
  default     = false
}

# ASG
variable "asg_attachment" {
  description = "If true AutoScalingGroup will be attached to created TargetGroup"
  type        = bool
  default     = false
}
variable "asg_name" {
  description = "If asg_attachment is true, asg_name indicated to which ASG LB should be attached"
  type        = string
  default     = ""
}

# EC2 BARE INSTANCE
variable "instances_to_attach" {
  description = "List to EC2 Identifiers to attach to LB"
  type        = list(any)
  default     = []
}
variable "instances_attachment_port" {
  description = "Port to which TargetGroup will forward traffic if instances_to_attach is not empty"
  type        = number
  default     = 80
}

# TARGET GROUP
variable "tg_custom_name" {
  description = "If true TargetGroup will have provided custom name by variable tg_name"
  type        = bool
  default     = false
}
variable "tg_name" {
  description = "Used only if tg_custom_name is true. Should be used only in specific usecases when preventing TG from replacement."
  type        = string
  default     = ""
}
variable "tg_protocol" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#protocol"
  type        = string
  default     = "TCP"
}
variable "tg_protocol_version" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#protocol_version"
  type        = string
  default     = "HTTP1"
}
variable "tg_port" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#port"
  type        = number
  default     = 8000
}
variable "tg_deregistration_delay" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#deregistration_delay"
  type        = number
  default     = 300
}
variable "tg_target_type" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#target_type"
  type        = string
  default     = "instance"
}

# STICKNESS
variable "stickiness_enabled" {
  description = "Boolean to enable / disable stickiness"
  type        = bool
  default     = false
}
variable "stickiness_type" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#type"
  type        = string
  default     = "source_ip"
}
variable "stickiness_cookie_duration" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#cookie_duration"
  type        = number
  default     = 86400
}
variable "stickiness_cookie_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#cookie_name"
  type        = string
  default     = ""
}

# HEALTH CHECK
variable "healthcheck_enabled" {
  description = "Whether health checks are enabled"
  type        = bool
  default     = true
}
variable "healthcheck_healthy_threshold" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#healthy_threshold"
  type        = number
  default     = 5
}
variable "healthcheck_interval" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#interval"
  type        = number
  default     = 30
}
variable "healthcheck_matcher" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#matcher"
  type        = string
  default     = "200-499"
}
variable "healthcheck_path" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#path"
  type        = string
  default     = "/"
}
variable "healthcheck_port" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check"
  type        = string
  default     = "traffic-port"
}
variable "healthcheck_protocol" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check"
  type        = string
  default     = "HTTP"
}
variable "healthcheck_timeout" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#timeout"
  type        = number
  default     = 5
}
variable "healthcheck_unhealthy_threshold" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#unhealthy_threshold"
  type        = number
  default     = 2
}
