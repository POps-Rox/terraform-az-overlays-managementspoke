# v1.0.0 - date

## [v2.0.0] - 2026-05-11

### Breaking changes

* Upgraded to `azurerm` provider `~> 4.20` (previously `>= 3.7.0, < 4.0`).
* Raised Terraform CLI floor from `>= 1.9.2` to `>= 1.10`.
* Consumers must set `ARM_SUBSCRIPTION_ID` (azurerm 4.x makes `subscription_id` required).
* All 3 example `versions.tf` files dropped `skip_provider_registration = true` from the `provider "azurerm"` block (argument removed in 4.x; replaced by `resource_provider_registrations`, default fine for init/validate).

### Bug fix (coupled to the 4.x rename)

* `azurerm_route_table.bgp_route_propagation_enabled` was previously set to `var.disable_bgp_route_propagation` directly — a botched rename from the 3.x `disable_bgp_route_propagation` attribute that inverted the documented behavior (default `var.disable_bgp_route_propagation = true` actually enabled BGP propagation). Fixed: now `!var.disable_bgp_route_propagation`, restoring 3.x semantics.

### Notes — `azapi` constraint kept at `~> 1.13`

Same constraint as managementhub: the transitive AVM module pins `azapi < 2.0.0`. Bumping to `~> 2.0` deferred to Phase 2.

### Audited (no change needed)

* `azurerm_network_watcher_flow_log.retention_policy { … }` block — **still valid in 4.x**.
* `azurerm_storage_account` `container_delete_retention_policy` / `delete_retention_policy` — module inputs to sibling overlay.
* `private_endpoint_network_policies_enabled` variables and resource args — already migrated in a prior pass (variable is `string`-typed, resource uses 4.x name `private_endpoint_network_policies`).


Added

- Add Something you added
