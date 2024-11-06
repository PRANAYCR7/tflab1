terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
#  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}

subscription_id      = "d5093934-1a30-426e-acb0-c14331a9b7fa"
client_id            = "81316734-1a33-4d3a-95ff-4254d9f8af62"
client_secret        = "aw18Q~JRQoyVHAWJgKNDS0bQEh2ENfCI.NU4XcGe"
tenant_id            = "7974832e-4b9b-49e6-bc93-b5695f510220"
  
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.rgname}"
  location = "${var.rglocation}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_address_space       = "${var.vnet_address_space}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.subnet}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  subnet_address_prefixes     = "${var.subnet_address_space}"
}
