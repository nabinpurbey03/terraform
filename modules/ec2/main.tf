#Launch Template
resource "aws_launch_template" "my_tf_template" {
  name_prefix   = var.template_name
  image_id      = var.ami
  instance_type = var.instance_type
}

#EC2
resource "aws_instance" "instances" {
  count = var.instance_count

  subnet_id = element(var.subnet_ids, count.index)
  launch_template {
    id      = aws_launch_template.my_tf_template.id
    version = "$Latest"
  }

  user_data = var.user_data

  vpc_security_group_ids = [var.sg_id]

  tags = {
    Name = "${var.template_name}-${count.index}"
  }
}
