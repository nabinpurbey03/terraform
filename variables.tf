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





