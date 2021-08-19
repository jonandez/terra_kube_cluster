module "prod_vpc" {
  source = "../../modules/aws/vpc"

  vpc_cidr_block           = var.prod_vpc_cidr_block
  vpc_enable_dns_hostnames = var.prod_vpc_enable_dns_hostnames
  vpc_tags                 = var.prod_vpc_tags
  vpc_pub_subnets          = var.prod_vpc_pub_subnets
  vpc_name                 = var.prod_name_vpc
  name_subnet_nat          = var.prod_vpc_pub_subnets[0].name
  vpc_pri_subnets          = var.prod_vpc_pri_subnets
}