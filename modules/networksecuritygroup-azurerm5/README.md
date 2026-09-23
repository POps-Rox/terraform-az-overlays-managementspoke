# Vendored network security group module for azurerm 5.x

This directory vendors `Azure/avm-res-network-networksecuritygroup/azurerm`
from upstream repository
`Azure/terraform-azurerm-avm-res-network-networksecuritygroup`, version
`v0.5.1`. It exists because upstream `v0.5.1` constrains `azurerm` to 4.x,
which is incompatible with this module's root provider constraint of
`>= 5.0, < 6.0`.

The upstream module is redistributed under the upstream MIT License, Copyright
(c) Microsoft Corporation. The upstream `LICENSE` file is retained unchanged in
this directory. This copy has been modified by POps-Rox.

## Changes from upstream v0.5.1

The following list was produced by diffing this vendored tree against
`Azure/terraform-azurerm-avm-res-network-networksecuritygroup` tag `v0.5.1`.

1. `terraform.tf`
   - `terraform.required_version`: upstream `>= 1.9, < 2.0` → vendored `>= 1.10`, matching this repository's Terraform baseline.
   - `required_providers.azapi.version`: upstream `~> 2.4` → vendored `~> 2.12`.
   - `required_providers.azurerm.version`: upstream `~> 4.0` → vendored `>= 5.0, < 6.0`.

2. `main.tf`, resource `azurerm_monitor_diagnostic_setting.this`
   - Added an `enabled_metric` dynamic block over `each.value.metric_categories`, with `category = enabled_metric.value`, so metric categories are emitted with the azurerm 5.x schema.

3. `variables.tf`, variable `diagnostic_settings`
   - Added validation requiring `length(v.log_categories) + length(v.log_groups) + length(v.metric_categories) > 0` for each diagnostic setting because azurerm 5.x requires at least one `enabled_log` or `enabled_metric` block.

4. Vendored packaging
   - Retained all upstream Terraform source files required by this module and the upstream `LICENSE`.
   - Omitted upstream ancillary repository files that are not used by this vendored module: upstream `.github/`, `.devcontainer/`, examples, tests, generated documentation fragments, support/contribution docs, and helper scripts.
   - Replaced the upstream generated module README with this provenance-focused README.
   - Added `NOTICE` documenting upstream source, version, retrieval date, license, and POps-Rox modifications.

No other Terraform source changes were made relative to upstream `v0.5.1`.

## Maintenance

This vendored copy receives no Dependabot coverage. Upstream changes must be
tracked manually.

Tracking issue: [POps-Rox/.github#27](https://github.com/POps-Rox/.github/issues/27).
Delete this vendored copy and return to the registry module source once upstream
supports azurerm 5.x.
