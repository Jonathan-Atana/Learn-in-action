module "autoscaling" {
  source = "./modules/ASG"

  project_name = var.project_name
  env = var.env
}

module "database" {
  source = "./modules/database"

  project_name = var.project_name
  env = var.env
}

module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  env = var.env
}