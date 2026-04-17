provider "aws" {
  region = "us-east-1"
}

# Get AZs
data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "roboshop-dev-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Public Subnets
resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  map_public_ip_on_launch = true

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "roboshop-dev-public-${count.index}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count = 2

  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index + 10}.0/24"

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "roboshop-dev-private-${count.index}"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

# Internet Route
resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Public Subnets
resource "aws_route_table_association" "public_assoc" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# =====================
# SSM PARAMETERS (VERY IMPORTANT)
# =====================

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/roboshop/dev/vpc_id"
  type  = "String"
  value = aws_vpc.main.id
}

resource "aws_ssm_parameter" "public_subnets" {
  name  = "/roboshop/dev/public_subnets"
  type  = "StringList"
  value = join(",", aws_subnet.public[*].id)
}

resource "aws_ssm_parameter" "private_subnets" {
  name  = "/roboshop/dev/private_subnets"
  type  = "StringList"
  value = join(",", aws_subnet.private[*].id)
}
