terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
    region = "us-east-2"
}

variable "flask_port" {
    type        = number
    default     = 5000
}

variable "http_port" {
    type        = number
    default     = 80
}

variable "ssh_port" {
    type        = number
    default     = 22
}

variable "outbound_anywhere" {
    type = number
    default = 0
}

# Security Group
resource "aws_security_group" "flask-terraform-sg" {
    name = "terraform-example-instance"

    ingress {
        description = "Flask"
        from_port   = var.flask_port
        to_port     = var.flask_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Webserver"
        from_port   = var.http_port
        to_port     = var.http_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH"
        from_port   = var.ssh_port
        to_port     = var.ssh_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Outbound"
        from_port   = var.outbound_anywhere
        to_port     = var.outbound_anywhere
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
    value       = aws_instance.flask.public_ip
    description = "Public IP of EC2 instance"
}

resource "aws_instance" "flask" {
    ami = "ami-0862be96e41dcbf74"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.flask-terraform-sg.id]
    tags = {
        Name = "Example"
    }
}

variable "datadog_api_key" {
  description = "Datadog API Key"
  type        = string
}