terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

#######################
# VPC and Subnet Module
#######################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "custom-vpc"
  cidr = "10.0.0.0/16"

  azs             = [var.az1, var.az2]
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
}

#######################
# Bastion Host Setup
#######################

# Security Group for Bastion Host: Only allow SSH from your IP
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH from my IP only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Bastion Host Instance in the Public Subnet
resource "aws_instance" "bastion" {
  ami                    = var.bastion_ami
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "bastion-host"
  }
}

#######################
# Private Instances Setup
#######################

# Security Group for Private Instances: Allow internal VPC traffic
resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Security group for private instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create 6 Private EC2 Instances using your custom AMI
resource "aws_instance" "private_instances" {
  count                  = 6
  ami                    = var.custom_ami_id 
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "private-instance-${count.index + 1}"
  }
}
