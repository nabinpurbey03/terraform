variable "name" {}
variable "vpc_id" {}
variable "public_subnets" { type = list(string) }
variable "alb_sg_ids" { type = list(string) }
variable "launch_template_id" {}
variable "asg_max_size" { default = 2 }
variable "asg_min_size" { default = 1 }
variable "asg_desired_capacity" { default = 1 }
