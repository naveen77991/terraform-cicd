
provider "aws" {
  region = "us-east-1"
}

# Get SG ID from SSM
data "aws_ssm_parameter" "sg_id" {
  name = "/roboshop/dev/sg_id"
}

# Get Public Subnets from SSM
data "aws_ssm_parameter" "public_subnets" {
  name = "/roboshop/dev/public_subnets"
}

# Convert subnet string to list
locals {
  public_subnet_list = split(",", data.aws_ssm_parameter.public_subnets.value)
}

# Bastion EC2
resource "aws_instance" "bastion" {
  ami           = "ami-0c02fb55956c7d316"   # Amazon Linux 2 (us-east-1)
  instance_type = "t2.micro"

  subnet_id = local.public_subnet_list[0]

  vpc_security_group_ids = [
    data.aws_ssm_parameter.sg_id.value
  ]

  tags = {
    Name = "roboshop-dev-bastion"
  }
}
