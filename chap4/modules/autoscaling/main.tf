module "iam_instance_profile" {
  source = "github.com/terraform-in-action/terraform-aws-iip"

  actions = ["logs:*", "rds:*"]
}

data "cloudinit_config" "main" {
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud_config.yaml", var.db_config)
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (official Ubuntu images)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_launch_template" "main" {
  name_prefix = "${var.env}-${var.project_name}"
  image_id = data.aws_ami.ubuntu.id
  key_name = var.ssh_keypair

  instance_type = "t2.micro"
  user_data = data.cloudinit_config.main.rendered
  vpc_security_group_ids = [ var.sg.websvr ]

  iam_instance_profile {
    name = module.iam_instance_profile.name
  }
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = "${var.env}-${var.project_name}-alb"
  load_balancer_type = "application"

  vpc_id = var.vpc.vpc_id
  subnets = var.vpc.public_subnets
  security_groups = [var.sg.lb]

  http_tcp_listeners = [
    {
        port = 80
        protocol = "HTTP"
        target_group_index = 0
    }
  ]

  target_groups = [
    {
        target_type = "instance"
        backend_port = 8080
        backend_protocol = "HTTP"
        name_prefix = "websvr"
    }
  ]
}

resource "aws_autoscaling_group" "main" {
  name = "${var.env}-${var.project_name}-asg"
  vpc_zone_identifier = var.vpc.private_subnets
  target_group_arns = module.alb.target_group_arns

  min_size = 1
  max_size = 3

  launch_template {
    id = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }
}