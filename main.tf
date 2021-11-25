provider "aws" {
  region = var.region
}

#vpc creation
resource "aws_vpc" "pc-vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    "Name" = "pc-vpc"
  }
}
#Subnet creation
resource "aws_subnet" "app-server" {
  cidr_block = var.subnet_cidr
  vpc_id = aws_vpc.pc-vpc.id
  availability_zone = var.az

  tags = {
    "Name" = "app-server"
  }

  depends_on = [
    aws_vpc.pc-vpc
  ]
}


#InternetGateway creation

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.pc-vpc.id

  tags = {
    "Name" = "gw"
  }

  depends_on = [
    aws_vpc.pc-vpc
  ]
}

#RouteTable Creation
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.pc-vpc.id

  route {
    cidr_block = local.any
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    "Name" = "public-route"
  }
  depends_on = [
    aws_vpc.pc-vpc
  ]
}

resource "aws_route_table_association" "pc-route-table" {
  subnet_id = aws_subnet.app-server.id
  route_table_id = aws_route_table.public-route.id
   
  depends_on = [
    aws_route_table.public-route
  ]
}

#Security Group 
resource "aws_security_group" "app-1" {
  name = "app-1"
  description = "Creating app subnet"
  vpc_id = aws_vpc.pc-vpc.id

   ingress {
    cidr_blocks = [ local.any ]
    description = "This is inboubd rule for app"
    from_port = local.appport
    protocol = local.tcp
    to_port = local.appport
  }

  ingress {
    cidr_blocks = [ local.any ]
    description = "This is inboubd rule for app"
    from_port = local.ssh
    protocol = local.tcp
    to_port = local.ssh
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  tags = {
    "Name" = "app-1"
  }

  depends_on = [
    aws_subnet.app-server
  ]
}
