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

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 7007
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 512
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = 1024
}

variable "health_check_path" {
  type    = string
  default = "/"
}
