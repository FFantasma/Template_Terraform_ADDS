terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.54.0"
    }
  }
}

provider "azurerm" {

  subscription_id = "12106da5-bae4-4684-a905-de0669e308ee"
  tenant_id       = "231800d7-f393-4413-a579-d72a2f586b33"

  features {
  }
}