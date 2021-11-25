resource "aws_instance" "app-1" {
    ami = "ami-09889d8d54f9e0a0e"
    associate_public_ip_address = true
    instance_type = var.appserverinstancetype
    key_name = "tf-1606"
    security_groups = [ aws_security_group.app-1.id ]
    subnet_id = aws_subnet.app-server.id

    #ssh connetion to remote server
    connection {
      type = "ssh"
      port = 22
      user = "ubuntu"
      private_key = file("./tf-1606.pem")
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
      "Name" = "app-1"
    }
}