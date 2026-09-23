# Functional tests for the management spoke overlay.
#
# These use mock_provider, so they execute without Azure credentials and are
# safe for pull requests from forks. They exercise naming precedence,
# conditional creation, tag merging, and location propagation that
# terraform validate cannot prove.

mock_provider "azapi" {
  mock_data "azapi_resource_list" {
    defaults = {
      output = {
        results = [
          {
            role_name = "Network Contributor"
            id        = "/providers/Microsoft.Authorization/roleDefinitions/00000000-0000-0000-0000-000000000006"
          },
          {
            role_name = "Owner"
            id        = "/providers/Microsoft.Authorization/roleDefinitions/00000000-0000-0000-0000-000000000007"
          },
          {
            role_name = "Storage Blob Data Contributor"
            id        = "/providers/Microsoft.Authorization/roleDefinitions/00000000-0000-0000-0000-000000000008"
          }
        ]
      }
    }
  }
}
mock_provider "random" {
  mock_resource "random_id" {
    defaults = {
      hex = "abcde"
    }
  }
}

mock_provider "azurerm" {
  mock_data "azurerm_client_config" {
    defaults = {
      client_id       = "00000000-0000-0000-0000-000000000001"
      object_id       = "00000000-0000-0000-0000-000000000002"
      subscription_id = "00000000-0000-0000-0000-000000000003"
      tenant_id       = "00000000-0000-0000-0000-000000000004"
    }
  }

  mock_data "azurerm_resource_group" {
    defaults = {
      id       = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/existing-management-rg"
      name     = "existing-management-rg"
      location = "eastus"
    }
  }

  mock_data "azurerm_network_watcher" {
    defaults = {
      id                  = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/NetworkWatcherRG/providers/Microsoft.Network/networkWatchers/NetworkWatcher_eastus"
      name                = "NetworkWatcher_eastus"
      resource_group_name = "NetworkWatcherRG"
      location            = "eastus"
    }
  }
}

mock_provider "popsrox" {
  mock_data "popsrox_resource_name" {
    defaults = {
      result = "generated-name"
    }
  }
}

variables {
  location                                     = "eastus"
  environment                                  = "public"
  deploy_environment                           = "dev"
  workload_name                                = "management"
  org_name                                     = "anoa"
  existing_resource_group_name                 = "existing-management-rg"
  existing_log_analytics_workspace_id          = "00000000-0000-0000-0000-000000000005"
  existing_log_analytics_workspace_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/logging-rg/providers/Microsoft.OperationalInsights/workspaces/law"
  existing_private_dns_zone_blob_id            = ["/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/dns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
  existing_hub_firewall_private_ip_address     = "10.0.0.4"
  virtual_network_address_space                = ["10.20.0.0/16"]
  spoke_storage_user_assigned_resource_ids     = []

  spoke_subnets = {
    default = {
      name                                       = "default"
      address_prefixes                           = ["10.20.1.0/24"]
      service_endpoints                          = []
      private_endpoint_network_policies_enabled  = "Disabled"
      private_endpoint_service_endpoints_enabled = false
      nsg_subnet_rules                           = {}
    }
  }
}

# ---------------------------------------------------------------------------
# Naming precedence
# ---------------------------------------------------------------------------

run "generated_names_are_used_when_custom_names_are_unset" {
  command = plan

  assert {
    condition     = local.spoke_vnet_name == "generated-name" && local.spoke_rt_name == "generated-name" && local.ddos_plan_name == "generated-name"
    error_message = "Generated names from popsrox_resource_name should be used when custom names are unset."
  }
}

run "custom_names_override_generated_names" {
  command = plan

  variables {
    custom_spoke_virtual_network_name = "custom-vnet"
    custom_spoke_route_table_name     = "custom-rt"
    custom_spoke_storage_account_name = "customstorageacct"
    ddos_plan_custom_name             = "custom-ddos"
  }

  assert {
    condition     = local.spoke_vnet_name == "custom-vnet" && local.spoke_rt_name == "custom-rt" && local.spoke_sa_name == "customstorageacct" && local.ddos_plan_name == "custom-ddos"
    error_message = "Custom names must take precedence over generated names."
  }
}

run "empty_custom_names_fall_through_to_generated_names" {
  command = plan

  variables {
    custom_spoke_virtual_network_name = ""
    custom_spoke_route_table_name     = ""
    custom_spoke_storage_account_name = ""
    ddos_plan_custom_name             = ""
  }

  assert {
    condition     = local.spoke_vnet_name == "generated-name" && local.spoke_rt_name == "generated-name" && local.ddos_plan_name == "generated-name"
    error_message = "Empty custom name strings must fall through to generated names."
  }
}

# ---------------------------------------------------------------------------
# Conditional count/enable logic
# ---------------------------------------------------------------------------

run "conditional_resources_are_disabled_by_default" {
  command = plan

  assert {
    condition     = length(module.mod_spoke_vnet_ddos) == 0
    error_message = "create_ddos_plan defaults to false, so the DDoS module should not be created."
  }

  assert {
    condition     = length(azurerm_route.force_internet_tunneling) == 0
    error_message = "enable_forced_tunneling_on_route_table defaults to false, so no forced-tunneling route should be planned."
  }

  assert {
    condition     = length(module.mod_scaffold_rg) == 0
    error_message = "create_spoke_resource_group defaults to false, so the resource-group module should not be created."
  }
}

run "conditional_resources_are_created_when_enabled" {
  command = plan

  variables {
    create_ddos_plan                       = true
    enable_forced_tunneling_on_route_table = true
    create_spoke_resource_group            = true
  }

  assert {
    condition     = length(module.mod_spoke_vnet_ddos) == 1
    error_message = "create_ddos_plan = true must create exactly one DDoS module instance."
  }

  assert {
    condition     = length(azurerm_route.force_internet_tunneling) == 1
    error_message = "enable_forced_tunneling_on_route_table = true must create exactly one forced-tunneling route."
  }

  assert {
    condition     = length(module.mod_scaffold_rg) == 1
    error_message = "create_spoke_resource_group = true must create exactly one resource-group module instance."
  }
}

# ---------------------------------------------------------------------------
# Tags and location passthrough
# ---------------------------------------------------------------------------

run "caller_supplied_tags_are_merged_in" {
  command = plan

  variables {
    add_tags = {
      costCenter = "cc-1234"
    }
  }

  assert {
    condition     = azurerm_route_table.routetable.tags["costCenter"] == "cc-1234" && azurerm_route_table.routetable.tags["env"] == "dev" && azurerm_route_table.routetable.tags["workload"] == "management"
    error_message = "Default and caller-supplied tags must be merged onto the route table."
  }
}

run "resource_group_location_is_passed_through" {
  command = plan

  assert {
    condition     = azurerm_route_table.routetable.location == "eastus"
    error_message = "The mocked resource-group location must be passed through to route table resources."
  }
}
