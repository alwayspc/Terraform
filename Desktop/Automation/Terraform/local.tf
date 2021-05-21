locals {
  subnets = ["web-1","app-1","db-1"]
  any = "0.0.0.0/0"
  ssh = 22
  http = 80
  tcp = "tcp"
  dbport = 3306
  appport = 8080
  db_subnet_group_name = "pcdb"
}

