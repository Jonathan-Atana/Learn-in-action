// Provider configurations
provider "aws" {
  region = "us-east-1"
}

// The AWS instance resource
resource "aws_instance" "hello-world" {
  ami           = "ami-02f624c08a83ca16f" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}

// Outputs
output "Amazon-Linux-2-AMI" {
  description = "The Image ID (AMI) of the Amazon Linux 2 instance"
  value       = "ami-02f624c08a83ca16f"
}