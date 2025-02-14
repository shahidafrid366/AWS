output "vpc_id" {
  value       = var.vpc_id
  description = "Value of the VPC ID"
}

output "aws_eks_cluster" {
  value       = var.aws_eks_cluster
  description = "Value of the EKS cluster"
}

output "aws_iam_role" {
  value       = var.aws_iam_role
  description = "Value of the IAM role for EKS"
}

output "eks_worker_node_policy" {
  value       = var.eks_worker_node_policy
  description = "ARN of the worker node policy"
}

output "eks_cni_policy" {
  value       = var.eks_cni_policy
  description = "ARN of the EKS CNI policy"
}

output "AmazonEC2ContainerRegistryReadOnly" {
  value       = var.AmazonEC2ContainerRegistryReadOnly
  description = "ARN of the Amazon EC2 Container Registry ReadOnly policy"
}

output "desired_size" {
  value       = var.desired_size
  description = "Desired size of the EKS worker nodes"
}

output "max_size" {
  value       = var.max_size
  description = "Maximum size of the EKS worker nodes"
}

output "min_size" {
  value       = var.min_size
  description = "Minimum size of the EKS worker nodes"
}

output "ec2_instance_type" {
  value       = var.ec2_instance_type
  description = "EC2 instance type"
}

output "key_pair_name" {
  value       = var.key_pair_name
  description = "Name of the SSH key pair"
}

