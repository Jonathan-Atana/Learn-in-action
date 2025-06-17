data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "${var.env}-${var.project_name}-vpc"
  cidr = "10.0.0.0/16"
  azs = data.aws_availability_zones.available.names

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
  create_database_subnet_group = true

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    env = var.env
    Team = "terraform"
  }
}

module "lb_sg" {
  source = "github.com/terraform-in-action/terraform-aws-sg"
  vpc_id = module.vpc.vpc_id

  description = "Security group for the ALB to recieve http inbound traffic"

  # allow comming traffic from everywhere
  ingress_rules = [{
    port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

module "websvr_sg" {
  source = "github.com/terraform-in-action/terraform-aws-sg"
  vpc_id = module.vpc.vpc_id

  description = "Security group for the servers to recieve inbound traffic on port 8080 and 22"

  # allow traffic comming only from the ALB's security group
  ingress_rules = [
    {
      port = 8080
      security_groups = [module.lb_sg.security_group.id]
    },
    {
      port = 22
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]
}

module "db_sg" {
  source = "github.com/terraform-in-action/terraform-aws-sg"
  vpc_id = module.vpc.vpc_id

  # allow traffic comming only from the webservers' security group
  ingress_rule = [
    {
        port = 3306
        security_groups = [module.websvr_sg.security_group.id]
    }
  ]
}