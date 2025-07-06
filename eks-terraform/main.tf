resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.private[*].id
  }
  depends_on = [aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy]
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.private[*].id

  remote_access {
    ec2_ssh_key = "my-eks-key"
    source_security_group_ids = [aws_security_group.eks_nodes.id]
  }

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = 3
    min_size     = 1
  }

  instance_types = [var.node_instance_type]
}