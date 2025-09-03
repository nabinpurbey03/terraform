#Virtual Private Cloud
resource "aws_vpc" "my_tf_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

#Public Subnet
resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.my_tf_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = { Name = each.key }
}

#Private Subnet
resource "aws_subnet" "private_subnet" {
  for_each = var.private_subnets

  vpc_id                  = aws_vpc.my_tf_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = { Name = each.key }
}

#Internet Gateway
resource "aws_internet_gateway" "my_tf_gateway" {
  vpc_id = aws_vpc.my_tf_vpc.id
  tags   = { Name = "${var.vpc_name}-igw" }
}

#Route Table
resource "aws_route_table" "tf-public-rt" {
  vpc_id = aws_vpc.my_tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_tf_gateway.id
  }
  tags = { Name = "tf-${var.vpc_name}-rt" }
}

resource "aws_route_table_association" "tf-public-rt-assoc" {
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.tf-public-rt.id
}
