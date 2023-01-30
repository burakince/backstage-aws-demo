module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = local.name
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway      = true
  single_nat_gateway      = true
  enable_dns_hostnames    = true
  map_public_ip_on_launch = false

  public_subnet_tags = {
    Name = "${local.name}-public-subnet"
  }

  public_subnet_tags_per_az = {
    "${local.region}a" = {
      "availability-zone" = "${local.region}a"
    }
  }

  tags = local.tags

  vpc_tags = {
    Name = "vpc-${local.name}"
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

  name   = local.name
  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]

  egress_rules = ["all-all"]

  tags = local.tags
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/aws/ecs/${local.name}"
  retention_in_days = 7

  tags = local.tags
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "4.1.3"

  cluster_name = local.name

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.ecs.name
      }
    }
  }

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
        base   = 20
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  tags = local.tags
}

resource "aws_cloudwatch_log_group" "backstage" {
  name_prefix       = "${local.name}-"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "backstage" {
  family = local.name

  container_definitions = <<EOF
[
  {
    "name": "${local.name}",
    "image": "${var.docker_registry}/${var.image_name}:${var.image_tag}",
    "cpu": 0,
    "memory": 128,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${local.region}",
        "awslogs-group": "${aws_cloudwatch_log_group.backstage.name}",
        "awslogs-stream-prefix": "ec2"
      }
    }
  }
]
EOF
}

resource "aws_ecs_service" "backstage" {
  name            = local.name
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.backstage.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}
