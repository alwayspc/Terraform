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
