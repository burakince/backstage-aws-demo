terraform {
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

  assume_role {
    role_arn     = "arn:aws:iam::775254019113:role/github-role"
    session_name = "githubrolesession"
  }
}
