output "vpc_id" {
  description = "The VPC ID"
  value       = module.vpc.vpc_id
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "private_instance_ids" {
  description = "IDs of the private instances"
  value       = aws_instance.private_instances[*].id
}
