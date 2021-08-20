resource "aws_iam_instance_profile" "node_profile" {
  name = var.name_k8s
  role = aws_iam_role.nodes.name
}

resource "aws_iam_role" "nodes" {
  name               = var.name_k8s
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

# EKS Full access policy
resource "aws_iam_policy" "eks_full_access" {
  name        = "eks_full_access"
  description = "EKS access for Jenkins Server"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode(
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "eksadministrator",
            "Effect": "Allow",
            "Action": "eks:*",
            "Resource": "*"
        }
    ]
})
}
# Attache policy to Jenkins server role 
resource "aws_iam_role_policy_attachment" "attachment_eks_policy" {
  role      = aws_iam_role.nodes.name
  policy_arn = aws_iam_policy.eks_full_access.arn
}

// temas de interfaces de red y cosas a nivel de plugins
resource "aws_iam_role_policy_attachment" "attachemt1" {
  role      = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

// permisos al register
resource "aws_iam_role_policy_attachment" "attachemt2" {
  role      = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "attachemt3" {
  role      = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}

resource "aws_iam_role_policy_attachment" "attachemt4" {
  role      = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}