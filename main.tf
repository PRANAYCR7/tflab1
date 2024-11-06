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

data "azurerm_resource_group" "rg" {
  name     = "labrg2"
}

data "azurerm_virtual_network" "vnet" {
  name                = "labvnet2"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  address_space       = ["10.1.1.0/16"]
}

data "azurerm_subnet" "subnet" {
  name                 = "labsubnet2"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}
