provider "azurerm" {
    features {}
    skip_provider_registration = "true"
    client_id = var.client-id
    client_secret = var.client-secret
    subscription_id = var.subscription-id
    tenant_id = var.tenant-id
}

module "azure-vm" {
    source = "./modules/azure-vm"   
}