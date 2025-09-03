variable "template_name" {}
variable "ami" {}
variable "instance_type" {}
variable "instance_count" { default = 1 }
variable "subnet_ids" { type = list(string) }
variable "sg_id" {}
variable "user_data" { type = string }
