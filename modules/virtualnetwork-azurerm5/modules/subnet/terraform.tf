terraform {
  required_version = ">= 1.10"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.12"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 5.0, < 6.0"
    }
  }
}
