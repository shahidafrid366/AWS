resource "aws_ecr_repository" "assignment-ecr" {
  name                 = "assignment-ecr"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "assignment-ecr"
    Environment = "Production"
  }
}

