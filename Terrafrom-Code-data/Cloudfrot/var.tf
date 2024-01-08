variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "access_key" {
  type    = string
  default = "AKIATWS3YIZYHECM4F5U"
}

variable "secret_key" {
  type    = string
  default = "7qg8QhawIlYZhSv9hNK4eBCEGrHDM7JRHOksj0IY"
}

variable "ami" {
  type    = string
  default = "ami-02a2af70a66af6dfb"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "pair1"
}

variable "availability_zone" {
  type    = string
  default = "ap-south-1a"
}

variable "instance_count" {
  type    = string
  default = "2"
}

variable "ecs_task_execution_role" {
  type    = string
  default = "myECcsTaskExecutionRole"
}

variable "app_image" {
  type    = string
  default = "nginx:latest"
}

variable "app_count" {
  type    = string
  default = "2"
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  type    = string
  default = "1024"
}

variable "fargate_memory" {
  type    = string
  default = "2048"
}

variable "rds_endpoint" {
  type    = string
  default = "your-rds-endpoint.amazonaws.com"
}

variable "rds_port" {
  type    = number
  default = 3306
}

variable "DOCKER_USERNAME" {
  type    = string
  default = "manoj3003"
}

variable "IMAGE_NAME" {
  type    = string
  default = "nginx-13"
}

variable "DOCKER_PASSWORD" {
  type    = string
  default = "dckr_pat_H2Q1b6BD2HOsk4xXruviLCWQzqI"
}

variable "user_arn" {
  default = "Terraform"
}

variable "user_arn_root" {
  default = "root"
}

variable "key_spec" {
  default = "SYMMETRIC_DEFAULT"
}

variable "enabled" {
  default = true
}

variable "kms_alias" {
  default = "demo"
}

variable "environment" {
  default = "non-prod"
}

variable "rotation_enabled" {
  default = true
}
