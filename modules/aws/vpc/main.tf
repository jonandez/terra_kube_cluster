###   Create VPC  ###
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = var.vpc_instance_tenancy
  enable_dns_hostnames = var.vpc_enable_dns_hostnames

  tags = merge("${var.vpc_tags}", { "Name" = "${var.vpc_name}" })
}

###   Create IG  ###
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge("${var.vpc_tags}", { "Name" = "${var.vpc_name}-ing" })
}

###   Create subnets  ### 
resource "aws_subnet" "this_sub_pub" {
  for_each = { for v in var.vpc_pub_subnets : v.name => v }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = merge("${each.value.tags}", { 
    Name = "${var.vpc_name}-${each.key}",
    "kubernetes.io/cluster/eks_cluster" = "shared",
    "kubernetes.io/role/elb" = 1,
  })
}

resource "aws_subnet" "this_sub_pri" {
  for_each = { for v in var.vpc_pri_subnets : v.name => v }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = merge("${each.value.tags}", { Name = "${var.vpc_name}-${each.key}" })
}

###   Create NAT GW  ###
resource "aws_eip" "this" {
  vpc  = true
  tags = var.vpc_tags
}
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = values(aws_subnet.this_sub_pub)[0].id
}


###   Create RT  ###
resource "aws_route_table" "this-r-t-pub" {
  vpc_id       = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = merge("${var.vpc_tags}", { Name = "${var.vpc_name}-r-t-pub" })
}

resource "aws_route_table" "this-r-t-pri" {
  vpc_id           = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
  tags = merge("${var.vpc_tags}", { Name = "${var.vpc_name}-r-t-pri" })
}

resource "aws_route_table_association" "this-as-pub" {
  count = length(aws_subnet.this_sub_pub)
  route_table_id = aws_route_table.this-r-t-pub.id
  subnet_id      = values(aws_subnet.this_sub_pub)[count.index].id
  depends_on     = [aws_subnet.this_sub_pub, aws_route_table.this-r-t-pub]
}

resource "aws_route_table_association" "this-as-pri" {
  count = length(aws_subnet.this_sub_pri)
  route_table_id = aws_route_table.this-r-t-pri.id
  subnet_id      = values(aws_subnet.this_sub_pri)[count.index].id
  depends_on     = [aws_subnet.this_sub_pri, aws_route_table.this-r-t-pri]
}