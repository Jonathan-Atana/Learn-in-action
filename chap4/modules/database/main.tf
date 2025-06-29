resource "random_password" "main" {
  length = 16
  special = true
}

resource "aws_db_instance" "main" {
  allocated_storage = 10
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  identifier = "${var.env}-${var.project_name}-db-instance"
  username = "admin"
  password = random_password.main.result
  db_name = "pets"
  vpc_security_group_ids = [ var.sg.db ]
  db_subnet_group_name = var.vpc.database_subnet_group_name
  skip_final_snapshot = true
}