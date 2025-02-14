output "alb_ingress_role_arn" {
  description = "ARN of the IAM role created for ALB Ingress Controller"
  value       = aws_iam_role.alb_ingress_role.arn
}

output "alb_ingress_policy_arn" {
  description = "ARN of the IAM policy attached to the ALB Ingress Controller"
  value       = aws_iam_policy.alb_ingress_policy.arn
}

