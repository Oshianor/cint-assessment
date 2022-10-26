resource "aws_route" "this" {
  for_each = var.routes

  route_table_id         = each.value["route_table"]
  destination_cidr_block = each.value["cidr"]
  transit_gateway_id     = lookup(each.value, "tgw_gw", true) ? each.value["tgw"] : null
  gateway_id             = lookup(each.value, "tgw_gw", true) ? null : each.value["gate_id"]
}
