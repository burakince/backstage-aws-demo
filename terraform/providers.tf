terraform {
  cloud {
    organization = "dataengineering"

    workspaces {
      name = "backstage-aws-demo"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider to Frankfurt
provider "aws" {
  region = local.region
}
