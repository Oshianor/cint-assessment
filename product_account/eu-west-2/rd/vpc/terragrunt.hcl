terraform {
  source = "../../../../modules/network/vpc"
}

include {
  path = find_in_parent_folders()
}


inputs = {
  name = "cint-vpc"
  cidr = "10.200.10.0/23"

  azs                   = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  private_subnets       = ["10.200.10.0/26", "10.200.10.64/26", "10.200.10.128/26"]
  public_subnets        = ["10.200.11.0/26", "10.200.11.64/26", "10.200.11.128/26"]
  public_subnet_suffix  = "public"
  private_subnet_suffix = "private"
  instance_tenancy      = "default"
  enable_dns_hostnames  = true
  enable_dns_support    = true
  enable_nat_gateway    = true
  single_nat_gateway    = true
  enable_vpn_gateway    = false
  enable_dhcp_options   = true

  tags = {
    component      = "network"
    env            = "rd"
    productbilling = "cint"
    team           = "devops"
    terraform      = true
  }
}
