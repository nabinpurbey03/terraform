variable "region" {
  description = "region for aws infrastructure creation"
  type        = string
  default     = "ap-south-1"
}

variable "cidr_block" {
  description = "cidr for vpc"
  type        = string
  default     = "192.168.0.0/24"
}

variable "vpc_name" {
  description = "name for vpc"
  type        = string
  default     = "my-tf-vpc"
}

variable "ami" {
  description = "ami type"
  type        = string
  default     = "ami-0861f4e788f5069dd"
}

variable "instance_type" {
  description = "instance type os an ec2"
  type        = string
  default     = "t2.micro"
}

variable "template_name" {
  description = "Prefix name of the launch template"
  type        = string
  default     = "tf-launch-template"
}

