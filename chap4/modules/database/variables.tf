variable "project_name" {
  description = "Name of the project"
  type = string
}

variable "env" {
  description = "Name of the project environment"
  type = string
  default = "dev"
}

variable "vpc" {
  description = "VPC in which the database will sit"
  type = any
}

variable "sg" {
  description = "Database security group"
  type = any
}