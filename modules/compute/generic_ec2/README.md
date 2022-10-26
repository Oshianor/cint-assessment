## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.63 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.this-tg-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.frontend_http_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [random_pet.asg_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_default_tags.tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [template_file.user_script](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs"></a> [access\_logs](#input\_access\_logs) | Map containing access logging configuration for load balancer. | `map(string)` | `{}` | no |
| <a name="input_asg_name"></a> [asg\_name](#input\_asg\_name) | Creates a unique name for autoscaling group beginning with the specified prefix | `string` | n/a | yes |
| <a name="input_block_device_mappings"></a> [block\_device\_mappings](#input\_block\_device\_mappings) | Additional EBS block devices to attach to the instance | `list(map(string))` | `[]` | no |
| <a name="input_create_asg"></a> [create\_asg](#input\_create\_asg) | Whether to create autoscaling group | `bool` | `true` | no |
| <a name="input_create_lb"></a> [create\_lb](#input\_create\_lb) | Controls if the Load Balancer should be created | `bool` | `true` | no |
| <a name="input_create_lc"></a> [create\_lc](#input\_create\_lc) | Whether to create launch configuration | `bool` | `true` | no |
| <a name="input_default_cooldown"></a> [default\_cooldown](#input\_default\_cooldown) | The amount of time, in seconds, after a scaling activity completes before another scaling activity can start | `number` | `300` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | The number of Amazon EC2 instances that should be running in the group | `string` | n/a | yes |
| <a name="input_drop_invalid_header_fields"></a> [drop\_invalid\_header\_fields](#input\_drop\_invalid\_header\_fields) | Indicates whether invalid header fields are dropped in application load balancers. Defaults to false. | `bool` | `false` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | If true, the launched EC2 instance will be EBS-optimized | `bool` | `false` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | Indicates whether cross zone load balancing should be enabled in application load balancers. | `bool` | `false` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Indicates whether HTTP/2 is enabled in application load balancers. | `bool` | `true` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Enables/disables detailed monitoring. This is enabled by default. | `bool` | `true` | no |
| <a name="input_enabled_metrics"></a> [enabled\_metrics](#input\_enabled\_metrics) | A list of metrics to collect. The allowed values are GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances | `list(string)` | <pre>[<br>  "GroupMinSize",<br>  "GroupMaxSize",<br>  "GroupDesiredCapacity",<br>  "GroupInServiceInstances",<br>  "GroupPendingInstances",<br>  "GroupStandbyInstances",<br>  "GroupTerminatingInstances",<br>  "GroupTotalInstances"<br>]</pre> | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling | `bool` | `false` | no |
| <a name="input_health_check_grace_period"></a> [health\_check\_grace\_period](#input\_health\_check\_grace\_period) | Time (in seconds) after instance comes into service before checking health | `number` | `300` | no |
| <a name="input_health_check_type"></a> [health\_check\_type](#input\_health\_check\_type) | Controls how health checking is done. Values are - EC2 and ELB | `string` | n/a | yes |
| <a name="input_http_tcp_listeners"></a> [http\_tcp\_listeners](#input\_http\_tcp\_listeners) | A list of maps describing the HTTP listeners or TCP ports for this ALB. Required key/values: port, protocol. Optional key/values: target\_group\_index (defaults to http\_tcp\_listeners[count.index]) | `any` | `[]` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | IAM instance profile | `string` | n/a | yes |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | The time in seconds that the connection is allowed to be idle. | `number` | `60` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The EC2 image ID to launch | `string` | n/a | yes |
| <a name="input_imdsv2_enabled"></a> [imdsv2\_enabled](#input\_imdsv2\_enabled) | If true IMDSv2 attributes will be set on instances and all needed token handling will be updated | `bool` | `false` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The size of instance to launch | `string` | n/a | yes |
| <a name="input_internal"></a> [internal](#input\_internal) | Boolean determining if the load balancer is internal or externally facing. | `bool` | `true` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack. | `string` | `"ipv4"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN of the AWS Key Management Service (AWS KMS) customer master key (CMK) to use when creating the encrypted volume | `string` | n/a | yes |
| <a name="input_launch_template"></a> [launch\_template](#input\_launch\_template) | The name of the launch template to use (if it is created outside of this module) | `string` | `""` | no |
| <a name="input_lc_name"></a> [lc\_name](#input\_lc\_name) | Creates a unique name for launch template beginning with the specified prefix | `string` | n/a | yes |
| <a name="input_load_balancer_create_timeout"></a> [load\_balancer\_create\_timeout](#input\_load\_balancer\_create\_timeout) | Timeout value when creating the ALB. | `string` | `"10m"` | no |
| <a name="input_load_balancer_delete_timeout"></a> [load\_balancer\_delete\_timeout](#input\_load\_balancer\_delete\_timeout) | Timeout value when deleting the ALB. | `string` | `"10m"` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | The type of load balancer to create. Possible values are application or network. | `string` | `"application"` | no |
| <a name="input_load_balancer_update_timeout"></a> [load\_balancer\_update\_timeout](#input\_load\_balancer\_update\_timeout) | Timeout value when updating the ALB. | `string` | `"10m"` | no |
| <a name="input_load_balancers"></a> [load\_balancers](#input\_load\_balancers) | A list of elastic load balancer names to add to the autoscaling group names | `list(string)` | `[]` | no |
| <a name="input_max_instance_lifetime"></a> [max\_instance\_lifetime](#input\_max\_instance\_lifetime) | The maximum amount of time, in seconds, that an instance can be in service, values must be either equal to 0 or between 604800 and 31536000 seconds. | `number` | `0` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum size of the auto scale group | `string` | n/a | yes |
| <a name="input_metrics_granularity"></a> [metrics\_granularity](#input\_metrics\_granularity) | The granularity to associate with the metrics to collect. The only valid value is 1Minute | `string` | `"1Minute"` | no |
| <a name="input_min_elb_capacity"></a> [min\_elb\_capacity](#input\_min\_elb\_capacity) | Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes | `number` | `0` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum size of the auto scale group | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Creates a unique name beginning with the specified prefix | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The resource name prefix and Name tag of the load balancer. Cannot be longer than 6 characters | `string` | `null` | no |
| <a name="input_placement_group"></a> [placement\_group](#input\_placement\_group) | The name of the placement group into which you'll launch your instances, if any | `string` | `""` | no |
| <a name="input_placement_tenancy"></a> [placement\_tenancy](#input\_placement\_tenancy) | The tenancy of the instance. Valid values are 'default', 'dedicated' or host | `string` | `"default"` | no |
| <a name="input_protect_from_scale_in"></a> [protect\_from\_scale\_in](#input\_protect\_from\_scale\_in) | Allows setting instance protection. The autoscaling group will not select instances with this setting for termination during scale in events. | `bool` | `false` | no |
| <a name="input_recreate_asg_when_lc_changes"></a> [recreate\_asg\_when\_lc\_changes](#input\_recreate\_asg\_when\_lc\_changes) | Whether to recreate an autoscaling group when launch configuration changes | `bool` | `false` | no |
| <a name="input_security_group"></a> [security\_group](#input\_security\_group) | The security group ID to create rules in and use in other resources, e.g. "sg-edcd9784" | `list(string)` | n/a | yes |
| <a name="input_subnet_mapping"></a> [subnet\_mapping](#input\_subnet\_mapping) | A list of subnet mapping blocks describing subnets to attach to network load balancer | `list(map(string))` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A list of subnets to associate with the load balancer. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f'] | `list(string)` | `null` | no |
| <a name="input_suspended_processes"></a> [suspended\_processes](#input\_suspended\_processes) | A list of processes to suspend for the AutoScaling Group. The allowed values are Launch, Terminate, HealthCheck, ReplaceUnhealthy, AZRebalance, AlarmNotification, ScheduledActions, AddToLoadBalancer. Note that if you suspend either the Launch or Terminate process types, it can prevent your autoscaling group from functioning properly. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend\_protocol, backend\_port | `any` | `[]` | no |
| <a name="input_termination_policies"></a> [termination\_policies](#input\_termination\_policies) | A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default | `list(string)` | <pre>[<br>  "Default"<br>]</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where to create security group | `string` | n/a | yes |
| <a name="input_vpc_zone_identifier"></a> [vpc\_zone\_identifier](#input\_vpc\_zone\_identifier) | A list of subnet IDs to launch resources in | `list(string)` | n/a | yes |
| <a name="input_wait_for_capacity_timeout"></a> [wait\_for\_capacity\_timeout](#input\_wait\_for\_capacity\_timeout) | A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior. | `string` | `"10m"` | no |
| <a name="input_wait_for_elb_capacity"></a> [wait\_for\_elb\_capacity](#input\_wait\_for\_elb\_capacity) | Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over min\_elb\_capacity behavior. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_http_tcp_listener_arns"></a> [http\_tcp\_listener\_arns](#output\_http\_tcp\_listener\_arns) | The ARN of the TCP and HTTP load balancer listeners created. |
| <a name="output_http_tcp_listener_ids"></a> [http\_tcp\_listener\_ids](#output\_http\_tcp\_listener\_ids) | The IDs of the TCP and HTTP load balancer listeners created. |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | The security group ID |
| <a name="output_target_group_arn_suffixes"></a> [target\_group\_arn\_suffixes](#output\_target\_group\_arn\_suffixes) | ARN suffixes of our target groups - can be used with CloudWatch. |
| <a name="output_target_group_arns"></a> [target\_group\_arns](#output\_target\_group\_arns) | ARNs of the target groups. Useful for passing to your Auto Scaling group. |
| <a name="output_target_group_names"></a> [target\_group\_names](#output\_target\_group\_names) | Name of the target group. Useful for passing to your CodeDeploy Deployment Group. |
| <a name="output_this_autoscaling_group_arn"></a> [this\_autoscaling\_group\_arn](#output\_this\_autoscaling\_group\_arn) | The ARN for this AutoScaling Group |
| <a name="output_this_autoscaling_group_availability_zones"></a> [this\_autoscaling\_group\_availability\_zones](#output\_this\_autoscaling\_group\_availability\_zones) | The availability zones of the autoscale group |
| <a name="output_this_autoscaling_group_default_cooldown"></a> [this\_autoscaling\_group\_default\_cooldown](#output\_this\_autoscaling\_group\_default\_cooldown) | Time between a scaling activity and the succeeding scaling activity |
| <a name="output_this_autoscaling_group_desired_capacity"></a> [this\_autoscaling\_group\_desired\_capacity](#output\_this\_autoscaling\_group\_desired\_capacity) | The number of Amazon EC2 instances that should be running in the group |
| <a name="output_this_autoscaling_group_health_check_grace_period"></a> [this\_autoscaling\_group\_health\_check\_grace\_period](#output\_this\_autoscaling\_group\_health\_check\_grace\_period) | Time after instance comes into service before checking health |
| <a name="output_this_autoscaling_group_health_check_type"></a> [this\_autoscaling\_group\_health\_check\_type](#output\_this\_autoscaling\_group\_health\_check\_type) | EC2 or ELB. Controls how health checking is done |
| <a name="output_this_autoscaling_group_id"></a> [this\_autoscaling\_group\_id](#output\_this\_autoscaling\_group\_id) | The autoscaling group id |
| <a name="output_this_autoscaling_group_load_balancers"></a> [this\_autoscaling\_group\_load\_balancers](#output\_this\_autoscaling\_group\_load\_balancers) | The load balancer names associated with the autoscaling group |
| <a name="output_this_autoscaling_group_max_size"></a> [this\_autoscaling\_group\_max\_size](#output\_this\_autoscaling\_group\_max\_size) | The maximum size of the autoscale group |
| <a name="output_this_autoscaling_group_min_size"></a> [this\_autoscaling\_group\_min\_size](#output\_this\_autoscaling\_group\_min\_size) | The minimum size of the autoscale group |
| <a name="output_this_autoscaling_group_name"></a> [this\_autoscaling\_group\_name](#output\_this\_autoscaling\_group\_name) | The autoscaling group name |
| <a name="output_this_autoscaling_group_target_group_arns"></a> [this\_autoscaling\_group\_target\_group\_arns](#output\_this\_autoscaling\_group\_target\_group\_arns) | List of Target Group ARNs that apply to this AutoScaling Group |
| <a name="output_this_autoscaling_group_vpc_zone_identifier"></a> [this\_autoscaling\_group\_vpc\_zone\_identifier](#output\_this\_autoscaling\_group\_vpc\_zone\_identifier) | The VPC zone identifier |
| <a name="output_this_launch_template_id"></a> [this\_launch\_template\_id](#output\_this\_launch\_template\_id) | The ID of the launch template |
| <a name="output_this_launch_template_name"></a> [this\_launch\_template\_name](#output\_this\_launch\_template\_name) | The name of the launch template |
| <a name="output_this_lb_arn"></a> [this\_lb\_arn](#output\_this\_lb\_arn) | The ID and ARN of the load balancer we created. |
| <a name="output_this_lb_arn_suffix"></a> [this\_lb\_arn\_suffix](#output\_this\_lb\_arn\_suffix) | ARN suffix of our load balancer - can be used with CloudWatch. |
| <a name="output_this_lb_dns_name"></a> [this\_lb\_dns\_name](#output\_this\_lb\_dns\_name) | The DNS name of the load balancer. |
| <a name="output_this_lb_id"></a> [this\_lb\_id](#output\_this\_lb\_id) | The ID and ARN of the load balancer we created. |
| <a name="output_this_lb_zone_id"></a> [this\_lb\_zone\_id](#output\_this\_lb\_zone\_id) | The zone\_id of the load balancer to assist with creating DNS records. |
