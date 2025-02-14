provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "arn:aws:eks:us-east-1:971422671164:cluster/Assignment-eks-cluster"
}

resource "aws_iam_policy" "alb_ingress_policy" {
  name        = "AWSALBIngressControllerIAMPolicy"
  description = "IAM Policy for ALB Ingress Controller"
  policy      = file("alb-ingress-policy.json")
}

resource "aws_iam_role" "alb_ingress_role" {
  name               = "alb-ingress-controller-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "alb_ingress_attachment" {
  role       = aws_iam_role.alb_ingress_role.name
  policy_arn = aws_iam_policy.alb_ingress_policy.arn
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "helm_release" "alb_ingress_controller" {
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = var.alb_ingress_version

  namespace = "kube-system"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "region"
    value = var.aws_region
  }
}

