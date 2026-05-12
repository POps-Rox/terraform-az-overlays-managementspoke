# v1.0.0 - date

## [2.1.0] - 2026-05-12

### Changed

- BREAKING: Bumped AVM module dependencies to azurerm 4.x-compatible versions:
  - `avm-res-network-virtualnetwork`: 0.4.2 → 0.17.1
  - `avm-res-network-ddosprotectionplan`: 0.2.0 → 0.3.0
  - `avm-res-network-networksecuritygroup`: 0.2.0 → 0.5.1
  - `avm-res-storage-storageaccount`: 0.2.7 → 0.7.0
- BREAKING: Refactored module inputs/outputs to match the new AVM schemas:
  - `avm-res-network-virtualnetwork` now requires `parent_id` (resource group ID) in place of `resource_group_name`.
  - `avm-res-network-virtualnetwork//modules/subnet` now takes `parent_id` (vnet ID) instead of `virtual_network = { resource_id = ... }`, and `service_endpoints` was renamed to `service_endpoints_with_location`.
  - `avm-res-storage-storageaccount` now requires `parent_id` (resource group ID); the `blob_properties` block was removed in the azapi rewrite — container/blob delete retention is no longer applied by the module.
  - Internal references like `module.spoke_vnet.resource.body.properties.addressSpace.addressPrefixes` switched to the new `address_spaces` / `address_prefixes` outputs.
- Removed the `azapi ~> 1.13` pin from `versions.tf`; the module now uses the fleet target `azapi ~> 2.0`.

### Fixed

- `terraform init` no longer fails with a provider constraint conflict between the root `azapi ~> 2.0` pin and the transitive AVM `azapi < 2.0` pin (root cause of issue #26).
- Two example output bindings in `examples/Commerical/basic_mgt_spoke` and `examples/Government/basic_mgt_spoke` (`storage_account_id` / `storage_account_name`) now reference the actual root output names (`spoke_storage_account_id` / `spoke_storage_account_name`).

### Known gaps

- `examples/Government/basic_mgt_spoke/main.tf` has a pre-existing `depends_on = [module.mod_id_network, module.mod_hub_network]` on a legacy provider-bearing module from `terraform-az-overlays-vnetpeering`. The referenced modules do not exist in this example and the legacy module rejects `depends_on`. Out of scope for this AVM bump; tracked separately.

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
