variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "az1" {
  description = "First availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "az2" {
  description = "Second availability zone"
  type        = string
  default     = "us-east-1b"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "my_ip" {
  description = "Your IP address in CIDR notation (e.g., 203.0.113.0/32)"
  type        = string
}

variable "bastion_ami" {
  description = "AMI for the bastion host (e.g., Amazon Linux 2)"
  type        = string
}

variable "custom_ami_id" {
  description = "The custom AMI ID created by Packer"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair to use for SSH"
  type        = string
}