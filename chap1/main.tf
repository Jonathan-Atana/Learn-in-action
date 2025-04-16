// Provider configurations
provider "aws" {
  region = "us-east-1"
}

// Data sources
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"] # Amazon's official AMIs

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

// The AWS instance resource
resource "aws_instance" "hello-world" {
  ami           = data.aws_ami.amazon-linux-2.id # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}

// Outputs
output "Amazon-Linux-2-Latest-AMI" {
  description = "The Image ID (AMI) of the Amazon Linux 2's latest instance"
  value       = data.aws_ami.amazon-linux-2.id
}