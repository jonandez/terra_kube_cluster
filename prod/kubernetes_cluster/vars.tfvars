prod_region                   = "us-east-1"
prod_name_vpc                 = "ac-xl-joseher-prod-vpc"
prod_vpc_cidr_block           = "10.0.0.0/16"
prod_vpc_enable_dns_hostnames = true

prod_vpc_tags = {
  Name = "ac-xl-terraform-lab"
  env  = "ac-xl-terraform-lab"
}

prod_vpc_pub_subnets = [
  {
    "name"                    = "public_subnet_1"
    "cidr_block"              = "10.0.0.0/24"
    "availability_zone"       = "us-east-1a"
    "map_public_ip_on_launch" = true
    "tags"  = {
      "env" = "ac-xl-terraform-lab"
    }
  },

    {
    "name"                    = "public_subnet_2"
    "cidr_block"              = "10.0.1.0/24"
    "availability_zone"       = "us-east-1b"
    "map_public_ip_on_launch" = true
    "tags"  = {
      "env" = "ac-xl-terraform-lab"
    }
  }
]

prod_vpc_pri_subnets = [
  {
    "name"                    = "private_subnet"
    "cidr_block"              = "10.0.2.0/24"
    "availability_zone"       = "us-east-1c"
    "map_public_ip_on_launch" = false
    "tags"  = {
      "env" = "ac-xl-terraform-lab"
    }
  }
]

####   K8s Cluster Variables
name_k8s = "eks_cluster"
// vars module ec2
prod_ami_id = "ami-0c2b8ca1dad447f8a"
prod_key_name = "eks_key"
prod_ec2_name_default = "eks_master"
