variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_session_token" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "docker_registry" {
  type    = string
  default = "ghcr.io"
}

variable "image_name" {
  type    = string
  default = "burakince/backstage-aws-demo"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 7007
}

variable "health_check_path" {
  type    = string
  default = "/"
}
