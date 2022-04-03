resource "aws_key_pair" "rodaina-key" {
  key_name = var.key_name
  public_key = file(var.public_key)
}

resource "aws_security_group" "rodainaSG" {
  vpc_id = var.vpc_id
  ingress {
    protocol  = "tcp"
    self      = true
    from_port = 22
    to_port   = 22
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "rodainaInstnace" {  
  ami = var.ami
  instance_type = var.instance_type
  tags = {
    "Name" = var.ec2Tag
  }

  key_name = aws_key_pair.rodaina-key.key_name
  vpc_security_group_ids = [aws_security_group.rodainaSG.id]
}

resource "aws_s3_bucket" "RodainaSB" {
  bucket = var.bucketName
  tags = {
    Name = "RodainaBucket"
  }
}

output "InstancePublicKey" {
  value = aws_instance.rodainaInstnace.public_ip
  description = "Public IP"
}

output "InstancePrivateKey" {
  value = aws_instance.rodainaInstnace.private_ip
  description = "Private IP"
}