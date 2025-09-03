output "vpc_id" { value = aws_vpc.my_tf_vpc.id }
output "public_subnet_ids" { value = values(aws_subnet.public_subnet)[*].id }
output "private_subnet_ids" { value = values(aws_subnet.private_subnet)[*].id }

