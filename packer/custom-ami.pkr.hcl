packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "chemch_assign8" {
  region        = "us-east-1"
  source_ami    = "ami-0c2b8ca1dad447f8a"
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  ami_name      = "chemch_assign8-AL-Dock-{{timestamp}}"
}

build {
  sources = [
    "source.amazon-ebs.chemch_assign8"
  ]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "echo '${var.ssh_public_key}' >> /home/ec2-user/.ssh/authorized_keys"
    ]
  }
}

variable "ssh_public_key" {
  type = string
}
