variable "aws_access_key" {
  description = "Access key"
  type        = string
}

variable "aws_secret_key" {
  description = "Secret key"
  type        = string
}

variable "aws_region" {
  description = "Region of AWS"
  type        = string
}

variable "vpc_id" {
  description = "Value for the VPC ID"
  type        = string
}

variable "aws_eks_cluster" {
  description = "Value for the EKS cluster"
  type        = string
}

variable "aws_iam_role" {
  description = "Value for the EKS IAM role"
  type        = string
}

variable "eks_worker_node_policy" {
  description = "Value for the EKS worker node policy"
  type        = string
}

variable "eks_cni_policy" {
  description = "Value for the EKS CNI policy"
  type        = string
}

variable "AmazonEC2ContainerRegistryReadOnly" {
  description = "Value for the Amazon EC2 Container Registry ReadOnly policy"
  type        = string
}

variable "desired_size" {
  description = "Desired size for the EKS worker nodes"
  type        = string
}

variable "max_size" {
  description = "Maximum size for the EKS worker nodes"
  type        = string
}

variable "min_size" {
  description = "Minimum size for the EKS worker nodes"
  type        = string
}

variable "ec2_instance_type" {
  description = "Instance type for EC2"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the SSH key pair"
  type        = string
}

