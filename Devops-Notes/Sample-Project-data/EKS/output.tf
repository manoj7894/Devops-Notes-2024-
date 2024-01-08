# Output variables for the EKS clusters
output "eks_cluster_name" {
  value = aws_eks_cluster.eks-cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = aws_eks_cluster.eks-cluster.certificate_authority[0].data
}

output "eks_cluster_role_arn" {
  value = aws_eks_cluster.eks-cluster.role_arn
}