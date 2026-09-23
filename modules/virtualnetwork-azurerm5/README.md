# Vendored virtual network module for azurerm 5.x

This directory vendors `Azure/avm-res-network-virtualnetwork/azurerm` from
upstream repository `Azure/terraform-azurerm-avm-res-network-virtualnetwork`,
version `v0.18.2`. It exists because the latest Terraform-1.10-compatible line
used by this module still constrains `azurerm` to 4.x; newer registry versions
remove that constraint but failed this repository's Terraform 1.10.5 CI due to
upstream `ipam_pools` validation/null-handling.

The upstream module is redistributed under the upstream MIT License, Copyright
(c) Microsoft Corporation. The upstream `LICENSE` file is retained unchanged in
this directory. This copy has been modified by POps-Rox.

## Changes from upstream v0.18.2

The following list was produced by diffing this vendored tree against
`Azure/terraform-azurerm-avm-res-network-virtualnetwork` tag `v0.18.2`.

1. `terraform.tf`
   - `terraform.required_version`: upstream `>= 1.9, < 2.0` → vendored `>= 1.10`, matching this repository's Terraform baseline.
   - `required_providers.azapi.version`: upstream `~> 2.4` → vendored `~> 2.12`.
   - `required_providers.azurerm.version`: upstream `~> 4.0` → vendored `>= 5.0, < 6.0`.

2. `modules/subnet/terraform.tf`
   - `terraform.required_version`: upstream `>= 1.9, < 2.0` → vendored `>= 1.10`.
   - `required_providers.azapi.version`: upstream `~> 2.5` → vendored `~> 2.12`.
   - `required_providers.azurerm.version`: upstream `~> 4.0` → vendored `>= 5.0, < 6.0`.

3. `modules/peering/terraform.tf`
   - `terraform.required_version`: upstream `>= 1.9, < 2.0` → vendored `>= 1.10`.
   - `required_providers.azapi.version`: upstream `~> 2.0` → vendored `~> 2.12`.

4. `variables.tf`, variable `ipam_pools`
   - Length validation changed from `var.ipam_pools == null || (length(var.ipam_pools) >= 1 && length(var.ipam_pools) <= 2)` → `var.ipam_pools == null ? true : (length(var.ipam_pools) >= 1 && length(var.ipam_pools) <= 2)` so Terraform 1.10.5 does not evaluate `length(null)`.

5. Vendored packaging
   - Retained all upstream Terraform source files required by this module, including nested Terraform submodules, and the upstream `LICENSE`.
   - Omitted upstream ancillary repository files that are not used by this vendored module: upstream `.github/`, `.devcontainer/`, examples, tests, generated documentation fragments, support/contribution docs, and helper scripts.
   - Replaced the upstream generated module README with this provenance-focused README.
   - Added `NOTICE` documenting upstream source, version, retrieval date, license, and POps-Rox modifications.

No other Terraform source changes were made relative to upstream `v0.18.2`.

## Maintenance

This vendored copy receives no Dependabot coverage. Upstream changes must be
tracked manually.

Tracking issue: [POps-Rox/.github#27](https://github.com/POps-Rox/.github/issues/27).
Delete this vendored copy and return to the registry module source once upstream
supports azurerm 5.x in a version that also works with this repository's
Terraform 1.10 CI baseline.
