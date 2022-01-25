terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.93.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "dev-test-group" {
  name     = "dev-test-group"
  location = "West Europe"
}

resource "azurerm_virtual_network" "dev-network" {
  name                = "dev-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.dev-test-group.location
  resource_group_name = azurerm_resource_group.dev-test-group.name
}

resource "azurerm_subnet" "spot-subnet" {
  name                 = "spot-subnet"
  resource_group_name  = azurerm_resource_group.dev-test-group.name
  virtual_network_name = azurerm_virtual_network.dev-network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic1" {
  for_each = { for nic in var.nics: nic.name => nic }
  name                = each.value.name
  location            = azurerm_resource_group.dev-test-group.location
  resource_group_name = azurerm_resource_group.dev-test-group.name

  ip_configuration {
    name                          = each.value.ipconfname
    subnet_id                     = azurerm_subnet.spot-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "spot-machine" {
  name                = "spot-machine"
  resource_group_name = azurerm_resource_group.dev-test-group.name
  location            = azurerm_resource_group.dev-test-group.location
  size                = "Standard_B2s"
  admin_username      = "dzenan"
  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
