variable "region" {
  type = string
  default = "ap-south-1"
  description = "Region is for az"
}

variable "vpc_cidr" {
  type = string
  default = "10.10.0.0/16"
  description = "vpc_cidr"
}

variable "cidrranges" {
  type = list(string)
  default = ["10.10.0.0/24","10.10.1.0/24","10.10.2.0/24"]
  description = "cidr"
}


variable "subnets" {
  type = list(string)
  default = ["web-1","app-1","db-1"]
  description = "subnets"
}

variable "subnetsaz" {
  type = list(string)
  default = ["ap-south-1a","ap-south-1b","ap-south-1c"]
  description = "az"
}