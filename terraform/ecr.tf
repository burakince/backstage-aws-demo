resource "aws_ecr_repository" "registry" {
  name = local.name

  force_delete = true
}

resource "aws_ecr_lifecycle_policy" "lifecycle_images_policy" {
  repository = aws_ecr_repository.registry.name

  policy = jsonencode(
    {
      rules = [
        {
          rulePriority = 1
          description  = "Expire untagged images older than 1 days"
          selection = {
            tagStatus   = "untagged"
            countType   = "sinceImagePushed"
            countUnit   = "days"
            countNumber = 1
          }
          action = {
            type = "expire"
          }
        },
        {
          rulePriority = 2
          description  = "Keep last 3 images"
          selection = {
            tagStatus   = "any"
            countType   = "imageCountMoreThan"
            countNumber = 3
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
            "ecr:GetAuthorizationToken",
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
