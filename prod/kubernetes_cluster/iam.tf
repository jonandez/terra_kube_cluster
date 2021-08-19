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

// temas de interfaces de red y cosas a nivel de plugins
resource "aws_iam_policy_attachment" "attachemt1" {
  name       = "attachmen1"
  roles      = [aws_iam_role.nodes.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

// permisos al register
resource "aws_iam_policy_attachment" "attachemt2" {
  name       = "attachmen2"
  roles      = [aws_iam_role.nodes.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_policy_attachment" "attachemt3" {
  name       = "attachmen3"
  roles      = [aws_iam_role.nodes.name]
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}

resource "aws_iam_policy_attachment" "attachemt4" {
  name       = "attachmen4"
  roles      = [aws_iam_role.nodes.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}