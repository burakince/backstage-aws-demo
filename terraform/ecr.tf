resource "aws_ecr_repository" "registry" {
  name = "${local.name}-container-registry"
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = aws_ecr_repository.registry.name

  policy = jsonencode(
    {
      rules = [
        {
          rulePriority = 1
          description  = "Keep last 3 images"
          selection = {
            tagStatus   = "tagged"
            countType   = "imageCountMoreThan"
            countNumber = 30
          }
          action = {
            type = "expire"
          }
        }
      ]
    }
  )
}

resource "aws_ecr_repository_policy" "repository_policy" {
  repository = aws_ecr_repository.registry.name

  policy = jsonencode(
    {
      Version = "2008-10-17"
      Statement = [
        {
          Sid       = "new policy"
          Effect    = "Allow"
          Principal = "*"
          Action = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:DescribeRepositories",
            "ecr:GetRepositoryPolicy",
            "ecr:ListImages",
            "ecr:DeleteRepository",
            "ecr:BatchDeleteImage",
            "ecr:SetRepositoryPolicy",
            "ecr:DeleteRepositoryPolicy"
          ]
        }
      ]
    }
  )
}
