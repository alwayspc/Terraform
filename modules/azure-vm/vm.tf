resource "azurerm_linux_virtual_machine" "webvm" {
    name = local.webvmname
    resource_group_name = data.azurerm_resource_group.rg.name
    location = var.location
    size = var.vm_size
    admin_username = var.admin-uname
    admin_password = var.admin-password
    network_interface_ids = [ azurerm_network_interface.vmnic.id ]
    disable_password_authentication = false

    os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  provisioner "remote-exec" {
      inline = [
        "sudo apt-get update",
        "sudo apt install python3-pip -y",
      ]

      connection {
        type = "ssh"
        user = var.admin-uname
        password = var.admin-password
        host = azurerm_linux_virtual_machine.webvm.public_ip_address
        }
  }

  depends_on = [
    azurerm_storage_account.mystorageaccount,
    azurerm_network_interface.vmnic

 ]
  
}