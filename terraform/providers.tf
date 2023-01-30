terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.2"
    }
  }
}

provider "aws" {
  region = local.region

  # assume_role {
  #   role_arn = "arn:aws:iam::775254019113:role/github-role"
  # }

  assume_role_with_web_identity {
    role_arn = "arn:aws:iam::775254019113:role/github-role"
    #   session_name            = "githubrolesession"
    #   web_identity_token_file = var.web_identity_token_file
  }
}
