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

  ingress {
    protocol  = "tcp"
    self      = true
    from_port = 80
    to_port   = 80
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
  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file(var.private_key)
  }

#   provisioner "file" {
#       source = "webserverscript.sh"
#       destination = "/home/ec2-user/"
#   }
  provisioner "file" {
      source = "webApp.php"
      destination = "/home/ec2-user/"
  }
  provisioner "remote-exec" {
    #   script = file("webserverscript.sh") 
    inline = [
        "sudo yum install httpd",
        "sudo systemctl enable httpd",
        "sudo systemctl start httpd",
        "sudo cp /home/ec2-user/webApp.php /var/www/html"
        
    ] 
  }

  key_name = aws_key_pair.rodaina-key.key_name
  vpc_security_group_ids = [aws_security_group.rodainaSG.id]
}

output "InstancePublicKey" {
  value = aws_instance.rodainaInstnace.public_ip
  description = "Public IP"
}

output "InstancePrivateKey" {
  value = aws_instance.rodainaInstnace.private_ip
  description = "Private IP"
}