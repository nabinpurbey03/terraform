output "instance_ids" { value = aws_instance.instances[*].id }
output "instance_ips" { value = aws_instance.instances[*].public_ip }
