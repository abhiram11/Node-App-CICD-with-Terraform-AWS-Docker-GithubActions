terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
  backend "s3" {
    key = "aws/ec2-deploy/terraform.tfstate"

  }
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "name" {
  ami           = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = var.private_key
    timeout     = "4m"
  }
  tags = {
    "name" = "DeployVM-Abhi"
  }
}
