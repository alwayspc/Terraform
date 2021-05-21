output "vpcid" {
  value = aws_vpc.pc-vpc.id
}

output "webserver" {
  value = aws_instance.ubuntu.id
}