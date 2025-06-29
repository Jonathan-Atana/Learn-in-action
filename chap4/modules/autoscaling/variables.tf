variable "project_name" {
  description = "Name of the project"
  type = string
}

variable "env" {
  description = "Name of the project environment"
  type = string
  default = "dev"
}

variable "ssh_keypair" {
  description = "SSH keypair to use for the instances"
  type = string
}

variable "vpc" {
  description = "Project VPC"
  type = any
}

variable "sg" {
  description = "Security groups"
  type = any
}

variable "db_config" {
  description = "Credentials for the database"
  type = object({
    user = string
    password = string
    hostname = string
    port = string
    database = string
  })
}