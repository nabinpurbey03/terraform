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
  source = "./modules/vpc"
  vpc_cidr_block = var.cidr_block
  vpc_name = var.vpc_name

  public_subnets = {
    "tf-public-1" = { cidr = "192.168.0.0/26", az = "ap-south-1a" }
    "tf-public-2" = { cidr = "192.168.0.64/26", az = "ap-south-1b" }
  }

  private_subnets = {
    "tf-private-1" = { cidr = "192.168.0.128/26", az = "ap-south-1a" }
    "tf-private-2" = { cidr = "192.168.0.192/26", az = "ap-south-1b" }
  }
}



