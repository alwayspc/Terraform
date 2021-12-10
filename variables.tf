variable "client-id" {
  type = string
  description = "client id"
  default = "212dbe50-0ee2-4d4b-a249-6a0938fcfa9a"
}

variable "client-secret" {
  type = string
  description = "client-secret id"
  default = "1v27Q~eeOVSgFGPOoZO7oF5KZSP1EDPMiiPA"
}

variable "subscription-id" {
  type = string
  description = "subscription-id"
  default = "db8a298e-ca49-4e17-8cb2-784524ebb2bb"
}

variable "tenant-id" {
  type = string
  description = "tenant-id"
  default = "e5a923d3-c95e-4edf-b85d-0f902935f3ab"
}

variable "location" {
    type = string
    description = "location where resources are to be created"
    default = "eastus"
}

variable "subnet" {
    type = string
    description = "subnet to be created"
    default = "tf-vm"
}

variable "tfvnetrange" {
    type = string
    description = "range of the vnet"
    default = "192.168.0.0/16"
}
variable "subnet_cidr" {
  type = string
  default = "192.168.1.0/24"
}

variable "admin-uname" {
  type = string
  description = "vm username"
  default = "azure"
}

variable "admin-password" {
  type = string
  description = "vm password"
  default = "azure@12345"
}
