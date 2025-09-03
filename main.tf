terraform {
  backend "local" {
    path = "./state-files/terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.11.0"
    }
  }
}

provider "aws" {
  region = var.region
}


module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr_block = var.cidr_block
  vpc_name       = var.vpc_name

  public_subnets = {
    "tf-public-1" = { cidr = "192.168.0.0/26", az = "ap-south-1a" }
    "tf-public-2" = { cidr = "192.168.0.64/26", az = "ap-south-1b" }
  }

  private_subnets = {
    "tf-private-1" = { cidr = "192.168.0.128/26", az = "ap-south-1a" }
    "tf-private-2" = { cidr = "192.168.0.192/26", az = "ap-south-1b" }
  }
}

module "ec2" {
  source        = "./modules/ec2"
  template_name = var.template_name
  ami           = var.ami
  instance_type = var.instance_type
  subnet_ids    = module.vpc.public_subnet_ids
  sg_id         = aws_security_group.ec2_sg.id
  user_data = templatefile("${path.root}/setup-ec2-web.sh.tmpl", {
    env     = "dev"
    appname = "myapp"
  })
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
