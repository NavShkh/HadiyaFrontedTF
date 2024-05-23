terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.104.2"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "sastate_grp" {
  name     = "sa-state-grp"
  location = "Central India"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.sastate_grp.name
  location                 = azurerm_resource_group.sastate_grp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_container" "sastate" {
  name                  = "$web"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "saweb_container" {
  name                  = "$web"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}