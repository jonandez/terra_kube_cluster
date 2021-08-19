data "aws_eks_cluster" "cluster" {
  name = module.prod_k8s.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.prod_k8s.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  #load_config_file       = false
  #version                = "~> 1.9"
}

module "prod_k8s" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.name_k8s
  cluster_version = "1.20"
  subnets         = module.prod_vpc.this_sub_pub
  vpc_id          = module.prod_vpc.this_vpc_id

  node_groups = [
    {
      name             = "node1"
      iam_role_arn     = aws_iam_role.nodes.arn
      max_capacity     = 5
      min_capacity     = 1
      desired_capacity = 1
    }
  ]
}