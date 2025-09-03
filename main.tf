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
}



