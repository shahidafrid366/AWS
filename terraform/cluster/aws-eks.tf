resource "aws_eks_cluster" "Assignment_eks_cluster" {
  name     = "Assignment-eks-cluster"
  role_arn = aws_iam_role.Assignment_eks_cluster_role.arn
  vpc_config {
     subnet_ids = [
      aws_subnet.private_subnet_a.id,
      aws_subnet.private_subnet_b.id,
      aws_subnet.private_subnet_c.id
    ]
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller,
  ]
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.Assignment_eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  role       = aws_iam_role.Assignment_eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_security_group" "eks_control_plane_sg" {
  vpc_id = aws_vpc.Assignment_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Allow traffic from within the VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-control-plane-sg"
  }
}

resource "aws_iam_role" "Assignment_eks_cluster_role" {
  name = "Assignment-eks-cluster_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role" "Assignment_eks_worker_role" {
  name = "Assignment-eks-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.Assignment_eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.Assignment_eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.Assignment_eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_node_group" "Assignment_eks_worker_nodes" {
  cluster_name    = aws_eks_cluster.Assignment_eks_cluster.name
  node_group_name = "Assignment_eks_worker_nodes"
  node_role_arn   = aws_iam_role.Assignment_eks_worker_role.arn
  
    subnet_ids  = [
      aws_subnet.private_subnet_a.id,
      aws_subnet.private_subnet_b.id,
      aws_subnet.private_subnet_c.id
    ]
 
  remote_access {
    ec2_ssh_key = var.key_pair_name
    source_security_group_ids = [aws_security_group.eks_worker_nodes_sg.id]
  }


  instance_types  = ["t2.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  depends_on = [aws_iam_role_policy_attachment.eks_worker_node_policy, aws_iam_role_policy_attachment.eks_cni_policy, aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly]
}

resource "aws_security_group" "eks_worker_nodes_sg" {
  vpc_id = aws_vpc.Assignment_vpc.id

  # Allow all traffic within the VPC (for pod-to-pod communication)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Allow inbound traffic from the EKS control plane on port 443
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Allow inbound traffic for NodePort services (optional, if using NodePort)
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust this to restrict access if needed
  }

  # Allow inbound traffic for MySQL (port 3306)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Restrict to private subnets
  }

  # Allow inbound traffic for PostgreSQL (port 5432)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Restrict to private subnets
  }

  # Allow inbound traffic for custom backend ports (e.g., port 8080)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Restrict to private subnets
  }

  # Allow outbound internet access (for pulling container images and updates)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-worker-nodes-sg"
  }
}
