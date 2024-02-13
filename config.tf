terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.91.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}