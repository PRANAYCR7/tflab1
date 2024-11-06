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

data "azurerm_resource_group" "rg1" {
  name     = "labrg2"
}

data "azurerm_virtual_network" "vnet1" {
  name                = "labvnet2"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "subnet1" {
  name                 = "labsubnet2"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

resource "azurerm_network_security_group" "nsg1" {
  name                = "NextOps-nsg1"
  resource_group_name = "${data.azurerm_resource_group.rg1.name}"
  location            = "${data.azurerm_resource_group.rg1.location}"
}

# NOTE: this allows RDP from any network
resource "azurerm_network_security_rule" "rdp" {
  name                        = "rdp"
  resource_group_name         = "${data.azurerm_resource_group.rg1.name}"
  network_security_group_name = "${azurerm_network_security_group.nsg1.name}"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet_assoc" {
  subnet_id                 = data.azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

resource "azurerm_network_interface" "nic1" {
  name                = "NextOpsVM-nic"
  resource_group_name = data.azurerm_resource_group.rg1.name
  location            = data.azurerm_resource_group.rg1.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "main" {
  name                            = "NextOpsVM"
  resource_group_name             = data.azurerm_resource_group.rg1.name
  location                        = data.azurerm_resource_group.rg1.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "P@ssw0rd1234!"
  network_interface_ids = [ azurerm_network_interface.nic1.id ]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
