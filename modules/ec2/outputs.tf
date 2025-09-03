output "instance_ids" { value = aws_instance.instances[*].id }
output "instance_ips" { value = aws_instance.instances[*].public_ip }
output "launch_template_id" { value = aws_launch_template.my_tf_template.id }
