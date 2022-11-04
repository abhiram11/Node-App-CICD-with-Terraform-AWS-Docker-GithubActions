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
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer_key.key_name
  vpc_security_group_ids = [aws_security_group.secgroup.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2-iam-profile.name
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

resource "aws_iam_instance_profile" "ec2-iam-profile" {
  name = "ec2-iam-profile"
  role = "EC2-ECR-ReadOnly"
}

resource "aws_security_group" "secgroup" {
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Egress security group by Abhi, publicly accessible, protocol -1 = for all"
    from_port        = 0
    to_port          = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
  }]
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Ingress (TCP) by Abhi, port 22 is for SSH"
    from_port        = 22
    to_port          = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Ingress (HTTP) by Abhi, port 80 is for HTTP"
      from_port        = 80
      to_port          = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
    }
  ]
}

resource "aws_key_pair" "deployer_key" {
  key_name   = var.key_name
  public_key = var.public_key
}
