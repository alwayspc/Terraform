provider "azurerm" {
    features {}
    skip_provider_registration = "true"
    #client_id = var.client-id
    #client_secret = var.client-secret
    #subscription_id = var.subscription-id
    #tenant_id = var.tenant-id
}

resource "azurerm_virtual_network" "tf-vnet" {
    name = "tf-vnet"
    resource_group_name = data.azurerm_resource_group.rg.name
    location = var.location
    address_space = [ var.tfvnetrange ]

    depends_on = [
      data.azurerm_resource_group.rg
    ]
  
}

resource "azurerm_subnet" "subnet" {
    name = var.subnet
    resource_group_name = data.azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.tf-vnet.name
    address_prefixes = [var.subnet_cidr]
  

    depends_on = [
      azurerm_virtual_network.tf-vnet
    ]
}

resource "azurerm_network_security_group" "webnsg" {
    name = local.webnsgname
    resource_group_name = data.azurerm_resource_group.rg.name
    location = var.location

    security_rule  {
      access = "Allow"
      description = "allow ssh"
      destination_address_prefix = "*"
      destination_port_range = "22"
      direction = "Inbound"
      name = "SSH"
      priority = 1001
      protocol = "TCP"
      source_address_prefix = "*"
      source_port_range = "*"
    } 
    security_rule  {
      access = "Allow"
      description = "allow http"
      destination_address_prefix = "*"
      destination_port_range = "80"
      direction = "Inbound"
      name = "Http"
      priority = 1011
      protocol = "TCP"
      source_address_prefix = "*"
      source_port_range = "*"
    }

    depends_on = [
      azurerm_virtual_network.tf-vnet,
      azurerm_subnet.subnet
    ]

  
}

resource "azurerm_public_ip" "webpublicip" {
    name = local.webpublicipname
    resource_group_name = data.azurerm_resource_group.rg.name
    location = var.location
    allocation_method = "Dynamic"

    depends_on = [
      azurerm_network_security_group.webnsg
    ]
  
}

resource "azurerm_network_interface" "vmnic" {
    name = local.nicname
    resource_group_name = data.azurerm_resource_group.rg.name
    location = var.location

    ip_configuration {
      name = "webnicconfig"
      subnet_id = azurerm_subnet.subnet.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.webpublicip.id
    }

    depends_on = [
        azurerm_public_ip.webpublicip,
        azurerm_network_security_group.webnsg,
        azurerm_subnet.subnet
      
    ]

  
}

resource "azurerm_network_interface_security_group_association" "web" {
    network_interface_id = azurerm_network_interface.vmnic.id
    network_security_group_id = azurerm_network_security_group.webnsg.id
  
}

resource "azurerm_storage_account" "mystorageaccount" {
    name = local.storaccountname
    resource_group_name = data.azurerm_resource_group.rg.name
    location = var.location
    account_replication_type = "LRS"
    account_tier = "Standard"
  
}

