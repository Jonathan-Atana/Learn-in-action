module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  env          = var.env
}

module "database" {
  source = "./modules/database"

  project_name = var.project_name
  env          = var.env

  vpc = module.networking.vpc
  sg  = module.networking.sg
}

module "autoscaling" {
  source = "./modules/autoscaling"

  project_name = var.project_name
  env          = var.env
  ssh_keypair  = var.ssh_keypair

  vpc       = module.networking.vpc
  sg        = module.networking.sg
  db_config = module.database.db-config
}