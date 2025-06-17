variable "project_name" {
  description = "Name of the project"
  type = string
}

variable "env" {
  description = "Name of the project environment"
  type = string
  default = "dev"
}

variable "ssh-keypair" {
  description = "SSH keypair to use for EC2 instance"
  type = string
  default = null
}

variable "region" {
  description = "AWS region for resources"
  type = string
}