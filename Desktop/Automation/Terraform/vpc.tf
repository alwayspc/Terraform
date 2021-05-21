provider "aws" {
  region = var.region
}

resource "aws_vpc" "pc-vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    "Name" = "pc-vpc"
  }
}

resource "aws_subnet" "subnets" {
  count = 3
  vpc_id = aws_vpc.pc-vpc.id
  #cidr_block = var.cidrranges[count.index]
  cidr_block = cidrsubnet(var.vpc_cidr,8,count.index)
  availability_zone = "${var.region}${count.index%2==0?"a":"b"}"

  tags = {
    "Name" = local.subnets[count.index]
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
    aws_vpc.pc-vpc,
    aws_subnet.subnets[0],
    aws_subnet.subnets[1]
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
    aws_vpc.pc-vpc,
    aws_subnet.subnets[0],
    aws_subnet.subnets[1]
  ]
}

#RouteTable Association Creation

resource "aws_route_table_association" "pc-route-table" {
  count = 2
  #for_each = data.aws_subnet_ids.publicsubnet.ids
  subnet_id = aws_subnet.subnets[count.index].id
  #subnet_id = each.key
  route_table_id = aws_route_table.public-route.id
   
  

  depends_on = [
    aws_route_table.public-route
  ]
}

#Private RouteTable Creation
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.pc-vpc.id

  tags = {
    "Name" = "private"
  }
  
  depends_on = [
    aws_vpc.pc-vpc,
    aws_subnet.subnets[2]  
  ]
}

#RouteTable Association Creation

resource "aws_route_table_association" "private-association" {
  subnet_id = aws_subnet.subnets[2].id
  route_table_id = aws_route_table.private.id

  depends_on = [
   aws_route_table.private
  ]
}


#Create web-1 instance security group

resource "aws_security_group" "web-1" {
  name = "web-1"
  description = "web"
  vpc_id = aws_vpc.pc-vpc.id

  ingress {
    cidr_blocks = [ local.any]
    description = "This is inboubd rule for DB"
    from_port = local.appport
    protocol = local.tcp
    to_port = local.appport
  }

  ingress {
    cidr_blocks = [ local.any ]
    description = "This is inboubd rule for DB"
    from_port = local.ssh
    protocol = local.tcp
    to_port = local.ssh
  }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name" = "web-1"
  }
}

#Create db security group

resource "aws_security_group" "db-security" {
  name = "dbsg"
  description = "Open port 3306"
  vpc_id = aws_vpc.pc-vpc.id

  ingress {
    cidr_blocks = [ var.vpc_cidr ]
    description = "This is inboubd rule for DB"
    from_port = local.dbport
    protocol = local.tcp
    to_port = local.dbport
  }

  ingress {
    cidr_blocks = [ var.vpc_cidr ]
    description = "This is inboubd rule for DB"
    from_port = local.ssh
    protocol = local.tcp
    to_port = local.ssh
  }

  ingress {
    cidr_blocks = [ var.vpc_cidr ]
    description = "This is inboubd rule for DB"
    from_port = local.http
    protocol = local.tcp
    to_port = local.http
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name" = "db-security"
  }
  depends_on = [
    aws_route_table.private
  ]    
}




