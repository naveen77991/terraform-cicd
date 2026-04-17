provider "aws" {
  region = "us-east-1"
}

# Get VPC ID from SSM
data "aws_ssm_parameter" "vpc_id" {
  name = "/roboshop/dev/vpc_id"
}

# Security Group
resource "aws_security_group" "main" {
  name        = "roboshop-dev-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Store SG ID in SSM
resource "aws_ssm_parameter" "sg_id" {
  name  = "/roboshop/dev/sg_id"
  type  = "String"
  value = aws_security_group.main.id
}
