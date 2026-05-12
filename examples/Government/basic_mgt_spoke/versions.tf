# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

terraform {
  required_version = ">= 1.10"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.20"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.13"
    }
    popsrox = {
      source  = "POps-Rox/azutils"
      version = "~> 1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  # NOTE: `skip_provider_registration = true` was removed in azurerm 4.x.
  # The replacement is `resource_provider_registrations = "none"` (or "core" / "all");
  # leaving it unset preserves the default for terraform init/validate.
  storage_use_azuread = true
  # subscription_id is provided by the consumer via ARM_SUBSCRIPTION_ID env var
}
