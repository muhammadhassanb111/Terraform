# Configure the AWS provider
provider "aws" {
  region = "eu-north-1"
}

# Configure the S3 backend for storing Terraform state
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket-name" # Replace with your S3 bucket name
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
  }
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

# Create a subnet
resource "aws_subnet" "example" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
}

# Create an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0989fb15ce71ba39e"
  instance_type = "t3.micro"
  key_name      = "terraform"  # Use your actual key name here
  subnet_id     = aws_subnet.example.id

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "MyEC2Instance"
  }
}

# Define outputs
output "instance_id" {
  value = aws_instance.example.id
}

output "public_ip" {
  value = aws_instance.example.public_ip
}

