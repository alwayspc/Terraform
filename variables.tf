variable "region" {
  type = string
  default = "us-west-2"
  description = "Performing operations in oregon region"
}
variable "az" {
  type = string
  default = "us-west-2a"
}
variable "vpc_cidr" {
  type = string
  default = "192.168.0.0/16"
}
variable "subnet_cidr" {
  type = string
  default = "192.168.1.0/24"
}
variable "appserverinstancetype" {
  type = string
  default = "t2.micro"
  description = "app server instance type"

}