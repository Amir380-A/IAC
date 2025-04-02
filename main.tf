provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "nginx_key" {
  key_name   = "nginx-key"
  public_key = file("${path.module}/nginx_key.pub")
}

resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

resource "aws_instance" "nginx" {
  ami                         = "ami-0c02fb55956c7d316"  # Ubuntu 20.04 LTS
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.nginx_key.key_name
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]

  tags = {
    Name = "nginx-server"
  }

}


output "public_ip" {
  value = aws_instance.nginx.public_ip
}

