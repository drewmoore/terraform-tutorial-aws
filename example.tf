terraform {
  required_version = "0.12.8"

  backend "remote" {
    organization = "amrumer"

    workspaces {
      name = "Tutorial-AWS-Workspace"
    }
  }
}

provider "aws" {
  version                 = "~> 2.47"
  region                  = var.region
  profile                 = "default"
  shared_credentials_file = "./.aws/credentials"
}

#module "consul" {
#  source      = "hashicorp/consul/aws"
#  version     = "0.7.3"
#  num_servers = "3"
#}

resource "aws_instance" "example" {
  ami           = var.amis[var.region]
  instance_type = "t2.micro"
  depends_on    = [aws_s3_bucket.example]

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}

resource "aws_eip" "ip" {
  vpc      = true
  instance = aws_instance.example.id
}

resource "aws_s3_bucket" "example" {
  acl    = "private"
  bucket = "amoore-terraform-tutorial-aws"
}
