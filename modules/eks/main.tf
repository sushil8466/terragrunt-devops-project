provider "aws" {
  region = var.aws_region
}

# ---------------- EKS IAM ROLE ----------------

resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.environment}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Action = "sts:AssumeRole"

        Effect = "Allow"

        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  role = aws_iam_role.eks_cluster_role.name
}

# ---------------- EKS CLUSTER ----------------

resource "aws_eks_cluster" "main" {
  name     = "${var.environment}-eks-cluster"

  role_arn = aws_iam_role.eks_cluster_role.arn

  version = "1.33"

  vpc_config {
    subnet_ids = [
      var.private_subnet_1_id,
      var.private_subnet_2_id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

# ---------------- NODE GROUP ROLE ----------------

resource "aws_iam_role" "node_group_role" {
  name = "${var.environment}-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Action = "sts:AssumeRole"

        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  role = aws_iam_role.node_group_role.name
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

  role = aws_iam_role.node_group_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_read_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

  role = aws_iam_role.node_group_role.name
}

# ---------------- NODE GROUP ----------------

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name

  node_group_name = "${var.environment}-node-group"

  node_role_arn = aws_iam_role.node_group_role.arn

  subnet_ids = [
    var.private_subnet_1_id,
    var.private_subnet_2_id
  ]

  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_read_policy
  ]
}
