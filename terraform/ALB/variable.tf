variable "aws_access_key" {
  description = "Access key"
  type        = string
}

variable "aws_secret_key" {
  description = "secretkey"
  type        = string
}

variable "aws_region" {
  description = "Region of aws"
  type        = string
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "alb_ingress_version" {
  description = "Version of ALB Ingress Controller Helm chart"
  type        = string
  default     = "1.4.4"
}

