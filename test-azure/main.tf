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

module "vms" {
  source = "./vms"

  vms = [
    {
      nic = {
        name = "nic1"
        ipconfname = "conf1"
      }

      pip = {
        allocation_method = "Dynamic"
      }

      vm = {
        name = "test"
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04-LTS"
        version   = "latest"
      }
    },

    {
      nic = {
        name = "nic2"
        ipconfname = "conf2"
      }

      pip = {
        allocation_method = "Dynamic"
      }

      vm = {
        name = "test2"
        publisher = "debian"
        offer     = "debian-10"
        sku       = "10-gen2"
        version   = "latest"
      }
    }

  ]
}

output "nics" {
  value = module.vms.nics
}

output "pips" {
  value = module.vms.pip
}

output "vmip" {
  value = module.vms.ips
}
