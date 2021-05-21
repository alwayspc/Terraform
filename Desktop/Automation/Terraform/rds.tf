#Create DB SUBNET
resource "aws_db_subnet_group" "pc-db-subnet" {
  name = local.db_subnet_group_name
  subnet_ids = [ aws_subnet.subnets[1].id, aws_subnet.subnets[2].id ]

  tags = {
    "Name" = "pc-db-subnet"
  }

  depends_on = [
      aws_subnet.subnets[1],
      aws_subnet.subnets[2]
     ]
}


#Creating MYSQL DB ON AWAMZON RDS
resource "aws_db_instance" "firstdb-mysql" {
  allocated_storage = 20
  engine = "mysql"
  engine_version = "8.0.20"
  instance_class = "db.t2.micro"
  name = "firstmysqlrds"
  username = "admin"
  password = "admin12345"
  vpc_security_group_ids = [ aws_security_group.db-security.id ]
  db_subnet_group_name = local.db_subnet_group_name
  skip_final_snapshot = true

  tags = {
    "Name" = "firstdb-mysql"
  }
  depends_on = [
    aws_db_subnet_group.pc-db-subnet
  ]
}