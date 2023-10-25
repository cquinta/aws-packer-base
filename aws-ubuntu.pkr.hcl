packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu-aws-${local.timestamp}"
  
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "ubuntu-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
    provisioner "shell" {
        inline = [
        "sleep 30",
        "sudo apt-get update -y",
        "sudo apt-get install -y nginx",
        "sudo systemctl start nginx"
        ]
    }
}
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

