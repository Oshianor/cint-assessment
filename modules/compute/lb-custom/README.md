## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.63 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.asg-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_lb.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.lb-listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.lb-listener-https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.target-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.instance-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [random_integer.web_target_group_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asg_attachment"></a> [asg\_attachment](#input\_asg\_attachment) | If true AutoScalingGroup will be attached to created TargetGroup | `bool` | `false` | no |
| <a name="input_asg_name"></a> [asg\_name](#input\_asg\_name) | If asg\_attachment is true, asg\_name indicated to which ASG LB should be attached | `string` | `""` | no |
| <a name="input_cert_arn"></a> [cert\_arn](#input\_cert\_arn) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#certificate_arn | `string` | `""` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#enable_cross_zone_load_balancing | `bool` | `true` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#enable_deletion_protection | `bool` | `false` | no |
| <a name="input_healthcheck_enabled"></a> [healthcheck\_enabled](#input\_healthcheck\_enabled) | Whether health checks are enabled | `bool` | `true` | no |
| <a name="input_healthcheck_healthy_threshold"></a> [healthcheck\_healthy\_threshold](#input\_healthcheck\_healthy\_threshold) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#healthy_threshold | `number` | `5` | no |
| <a name="input_healthcheck_interval"></a> [healthcheck\_interval](#input\_healthcheck\_interval) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#interval | `number` | `30` | no |
| <a name="input_healthcheck_matcher"></a> [healthcheck\_matcher](#input\_healthcheck\_matcher) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#matcher | `string` | `"200-499"` | no |
| <a name="input_healthcheck_path"></a> [healthcheck\_path](#input\_healthcheck\_path) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#path | `string` | `"/"` | no |
| <a name="input_healthcheck_port"></a> [healthcheck\_port](#input\_healthcheck\_port) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check | `string` | `"traffic-port"` | no |
| <a name="input_healthcheck_protocol"></a> [healthcheck\_protocol](#input\_healthcheck\_protocol) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check | `string` | `"HTTP"` | no |
| <a name="input_healthcheck_timeout"></a> [healthcheck\_timeout](#input\_healthcheck\_timeout) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#timeout | `number` | `5` | no |
| <a name="input_healthcheck_unhealthy_threshold"></a> [healthcheck\_unhealthy\_threshold](#input\_healthcheck\_unhealthy\_threshold) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#unhealthy_threshold | `number` | `2` | no |
| <a name="input_https_redirect"></a> [https\_redirect](#input\_https\_redirect) | If true additional listener will be created for HTTP to HTTPS redirection | `bool` | `false` | no |
| <a name="input_instances_attachment_port"></a> [instances\_attachment\_port](#input\_instances\_attachment\_port) | Port to which TargetGroup will forward traffic if instances\_to\_attach is not empty | `number` | `80` | no |
| <a name="input_instances_to_attach"></a> [instances\_to\_attach](#input\_instances\_to\_attach) | List to EC2 Identifiers to attach to LB | `list(any)` | `[]` | no |
| <a name="input_lb_internal"></a> [lb\_internal](#input\_lb\_internal) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#internal | `bool` | `true` | no |
| <a name="input_lb_logs_bucket"></a> [lb\_logs\_bucket](#input\_lb\_logs\_bucket) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#bucket | `string` | n/a | yes |
| <a name="input_lb_name"></a> [lb\_name](#input\_lb\_name) | LoadBalancer name. In TargetGroup name will be shortened to 25 characters | `string` | n/a | yes |
| <a name="input_lb_security_groups"></a> [lb\_security\_groups](#input\_lb\_security\_groups) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#security_groups | `list(any)` | `[]` | no |
| <a name="input_lb_subnets"></a> [lb\_subnets](#input\_lb\_subnets) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#subnets | `list(any)` | `[]` | no |
| <a name="input_lb_type"></a> [lb\_type](#input\_lb\_type) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#load_balancer_type | `string` | `"network"` | no |
| <a name="input_listener_port"></a> [listener\_port](#input\_listener\_port) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#port | `number` | `443` | no |
| <a name="input_listener_protocol"></a> [listener\_protocol](#input\_listener\_protocol) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#protocol | `string` | `"HTTPS"` | no |
| <a name="input_stickiness_cookie_duration"></a> [stickiness\_cookie\_duration](#input\_stickiness\_cookie\_duration) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#cookie_duration | `number` | `86400` | no |
| <a name="input_stickiness_cookie_name"></a> [stickiness\_cookie\_name](#input\_stickiness\_cookie\_name) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#cookie_name | `string` | `""` | no |
| <a name="input_stickiness_enabled"></a> [stickiness\_enabled](#input\_stickiness\_enabled) | Boolean to enable / disable stickiness | `bool` | `false` | no |
| <a name="input_stickiness_type"></a> [stickiness\_type](#input\_stickiness\_type) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#type | `string` | `"source_ip"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to attach to all resources, most common keys: Name, component, environment, productbilling, team | `map(any)` | `{}` | no |
| <a name="input_tg_custom_name"></a> [tg\_custom\_name](#input\_tg\_custom\_name) | If true TargetGroup will have provided custom name by variable tg\_name | `bool` | `false` | no |
| <a name="input_tg_deregistration_delay"></a> [tg\_deregistration\_delay](#input\_tg\_deregistration\_delay) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#deregistration_delay | `number` | `300` | no |
| <a name="input_tg_name"></a> [tg\_name](#input\_tg\_name) | Used only if tg\_custom\_name is true. Should be used only in specific usecases when preventing TG from replacement. | `string` | `""` | no |
| <a name="input_tg_port"></a> [tg\_port](#input\_tg\_port) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#port | `number` | `8000` | no |
| <a name="input_tg_protocol"></a> [tg\_protocol](#input\_tg\_protocol) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#protocol | `string` | `"TCP"` | no |
| <a name="input_tg_protocol_version"></a> [tg\_protocol\_version](#input\_tg\_protocol\_version) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#protocol_version | `string` | `"HTTP1"` | no |
| <a name="input_tg_target_type"></a> [tg\_target\_type](#input\_tg\_target\_type) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#target_type | `string` | `"instance"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC Identifier where TargetGroup will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | n/a |
| <a name="output_lb_lb_dns_name"></a> [lb\_lb\_dns\_name](#output\_lb\_lb\_dns\_name) | n/a |
| <a name="output_lb_lb_zone_id"></a> [lb\_lb\_zone\_id](#output\_lb\_lb\_zone\_id) | n/a |
| <a name="output_lb_target_grp_arn"></a> [lb\_target\_grp\_arn](#output\_lb\_target\_grp\_arn) | n/a |
| <a name="output_lb_target_grp_id"></a> [lb\_target\_grp\_id](#output\_lb\_target\_grp\_id) | n/a |
