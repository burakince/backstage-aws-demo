terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "dataengineering"

    workspaces {
      name = "backstage-aws-demo"
    }
  }
}