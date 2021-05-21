resource "aws_instance" "ubuntu" {
  ami = "ami-04bde106886a53080"
  associate_public_ip_address = true
  availability_zone = var.subnetsaz[0]
  instance_type = "t2.micro"
  key_name = "terraform"
  vpc_security_group_ids = [ aws_security_group.web-1.id ]
  subnet_id = aws_subnet.subnets[0].id

  connection {
    type = "ssh"
    port = 22
    user = "ubuntu"
    private_key = file("./terraform.pem")
    host = self.public_ip
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install apache2 -y",
    ]
  }
  
  tags = {
    "Name" = "webserver"
  }
  depends_on = [
    aws_db_instance.firstdb-mysql
  ]
  
}




