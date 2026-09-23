# Vendored DDoS protection plan module for azurerm 5.x

This directory vendors `Azure/avm-res-network-ddosprotectionplan/azurerm` from
upstream repository
`Azure/terraform-azurerm-avm-res-network-ddosprotectionplan`, version `v0.3.0`.
It exists because upstream `v0.3.0` constrains `azurerm` to `< 5.0`, which is
incompatible with this module's root provider constraint of `>= 5.0, < 6.0`.

The upstream module is redistributed under the upstream MIT License, Copyright
(c) Microsoft Corporation. The upstream `LICENSE` file is retained unchanged in
this directory. This copy has been modified by POps-Rox.

## Changes from upstream v0.3.0

The following list was produced by diffing this vendored tree against
`Azure/terraform-azurerm-avm-res-network-ddosprotectionplan` tag `v0.3.0`.

1. `terraform.tf`
   - `terraform.required_version`: upstream `>= 1.6.0` → vendored `>= 1.10`, matching this repository's Terraform baseline.
   - `required_providers.azurerm.version`: upstream `>= 3.116, < 5.0` → vendored `>= 5.0, < 6.0`.

2. Vendored packaging
   - Retained all upstream Terraform source files required by this module and the upstream `LICENSE`.
   - Omitted upstream ancillary repository files that are not used by this vendored module: upstream `.github/`, `.devcontainer/`, examples, tests, generated documentation fragments, support/contribution docs, and helper scripts.
   - Replaced the upstream generated module README with this provenance-focused README.
   - Added `NOTICE` documenting upstream source, version, retrieval date, license, and POps-Rox modifications.

No other Terraform source changes were made relative to upstream `v0.3.0`.

## Maintenance

This vendored copy receives no Dependabot coverage. Upstream changes must be
tracked manually.

Tracking issue: [POps-Rox/.github#27](https://github.com/POps-Rox/.github/issues/27).
Delete this vendored copy and return to the registry module source once upstream
supports azurerm 5.x.
