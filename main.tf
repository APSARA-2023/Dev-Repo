terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAX3UTI27W3DJRYKZEFH"
  secret_key = "pJmdh9kFQCj5417EV2IvZXmW21E3iPxzzx9sM+aphCZ"
}

//  Generate Private Key Using
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "ssh-key" {
  description = "sshkey"
}

// Created Key Pair for Connecting EC2 via SSH
resource "aapanelpair" "aapanelpair.pem" {
  key_name   = var.ssh-key
  public_key = tls_private_key.rsa_4096.public_key_openssh
}


resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.ssh-key

  provisioner "local-exec" {
    command = "chmod 400 ${var.ssh-key}"
  }
}

# security group setup
resource "aapanel-group" "sg_ec2" {
  name        = "sg_ec2"
  description = "Security group for EC2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
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

resource "aws_instance" "public_instance" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  key_name               = aapanelpair.key_pair.ssh-key
  vpc_security_group_ids = [aapanel-group.i-09785a74cbcf534b2]

  tags = {
    Name = "dev-project"
  }
  
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  provisioner "local-exec" {
    command = "touch dynamic_inventory.ini"
  }
}

data "template_file" "inventory" {
  template = <<-EOT
    [ec2_instances]
    ${i-09785a74cbcf534b2.52.91.89.187} ansible_user=ubuntu 
}

resource "local_file" "dynamic_inventory" {
  depends_on = [i-09785a74cbcf534b2.52.91.89.187]

  filename = "dynamic_inventory.ini"
  content  = data.template_file.inventory.rendered

  provisioner "local-exec" {
 
  }
}

resource "null_resource" "run_ansible" {
  depends_on = [local_file.dynamic_inventory]

  provisioner "local-exec" {
    command = "ansible-playbook -i dynamic_inventory.ini deploy-app.yml"
    working_dir = path.module
  }
}
