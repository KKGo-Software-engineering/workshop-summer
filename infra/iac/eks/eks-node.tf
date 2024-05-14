resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids = [
    aws_subnet.private-1a.id,
    aws_subnet.private-1b.id
  ]

  capacity_type  = "ON_DEMAND"   # or ON_DEMAND
  instance_types = ["t3.medium"] # or ["t3.medium"]
  disk_size      = 20

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}
