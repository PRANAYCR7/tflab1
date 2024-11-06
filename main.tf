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

terraform {
  backend "azurerm" {
    resource_group_name  = "${var.rgname}"             # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "${var.storage_account_name}"                                 # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "${var.container_name}"                                  # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "prod.terraform.tfstate"                   # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
    access_key           = "lu31yf+GcJN/w3+HeQ3CMc2fXl20KAm+RoqTxmIr65NBs8SgwzwjK9psSYUwZwO3smALWvv6uneR+AStEnbFCw=="  # Can also be set via `ARM_ACCESS_KEY` environment variable.
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.rgname}"
  location = "${var.rglocation}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["${var.vnet_address_space}"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.subnet}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["${var.subnet_address_space}"]
}
