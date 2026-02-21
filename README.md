# Spacelift Root Bootstrap (Tier 0)

This repository serves as the "Founder" for the entire Spacelift management plane. It follows a high-assurance, environment-templated pattern to initialize the foundation of a Spacelift account.

## Overview

The bootstrap stack is the first automated layer of the organization. It autonomously creates top-level environment containers, establishes local governance, and deploys the Tier 1 orchestrator stacks required for downstream management.

## Technical Library

Detailed documentation is organized by functional area in the `docs/` directory:

- **[Architecture Blueprint](docs/architecture.md)**: Cellular isolation, assurance tiering, and logical hierarchy.
- **[Operations Manual](docs/operations.md)**: Manifest management, CLI usage, and validation gates.
- **[Recovery Manifesto](docs/recovery.md)**: Definitive step-by-step instructions for Nuke and Pave operations.
- **[Bootstrap Seed Guide](scripts/bootstrap-seed/README.md)**: Instructions for the local "Bootloader" setup.

## Quick Start

1. **Seeding**: Initialize the foundational identity and root policies via the [Bootstrap Seed process](scripts/bootstrap-seed/README.md).
2. **Handoff**: Trigger the `sl-root-bootstrap` stack in the Spacelift UI to build the multi-environment cascade defined in `manifests/management-plane.yaml`.
3. **Validation**: Use `local-preview` via `spacectl` to verify changes before merging to `main`.

## Maintenance

The management plane is data-driven. Scale the organization by updating the registry in `manifests/management-plane.yaml`.

Run assurance gates locally before merge:
`./scripts/assurance-gate.sh`

Contract and gate details: `docs/assurance-gates.md`.

## TF Docs

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_spacelift"></a> [spacelift](#requirement\_spacelift) | ~> 1.44 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_spacelift"></a> [spacelift](#provider\_spacelift) | 1.44.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [spacelift_policy.env_approval](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/policy) | resource |
| [spacelift_policy.env_branch_guard](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/policy) | resource |
| [spacelift_policy.env_push_flow](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/policy) | resource |
| [spacelift_role_attachment.admin_stacks](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/role_attachment) | resource |
| [spacelift_space.env_root](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/space) | resource |
| [spacelift_space.env_sub_space](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/space) | resource |
| [spacelift_stack.admin_stacks](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/stack) | resource |
| [spacelift_role.space_admin](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/data-sources/role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_space_id"></a> [admin\_space\_id](#input\_admin\_space\_id) | The parent space for environment containers | `string` | `"root"` | no |
| <a name="input_admin_stacks_branch"></a> [admin\_stacks\_branch](#input\_admin\_stacks\_branch) | n/a | `string` | `"main"` | no |
| <a name="input_admin_stacks_repo"></a> [admin\_stacks\_repo](#input\_admin\_stacks\_repo) | n/a | `string` | `"sl-admin-stacks"` | no |
| <a name="input_allowed_assurance_tiers"></a> [allowed\_assurance\_tiers](#input\_allowed\_assurance\_tiers) | Allowed assurance\_tier values for environments in the management manifest. | `list(string)` | <pre>[<br/>  "tier-0",<br/>  "tier-1",<br/>  "tier-2",<br/>  "tier-3",<br/>  "tier-10"<br/>]</pre> | no |
| <a name="input_enable_auto_deploy"></a> [enable\_auto\_deploy](#input\_enable\_auto\_deploy) | Enables auto-deploy for the management plane orchestrators | `bool` | `false` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | !!!!! DO NOT CHANGE THIS IF YOU DO NOT WANT THINGS TO GET DELETED IT ALLOWS DELETION OF FOUNDATIONAL INFRA!!!!!! | `bool` | `true` | no |
| <a name="input_enforce_lowercase_environment_names"></a> [enforce\_lowercase\_environment\_names](#input\_enforce\_lowercase\_environment\_names) | When true, all environment names in the manifest must be lowercase. | `bool` | `false` | no |
| <a name="input_manifest_supported_versions"></a> [manifest\_supported\_versions](#input\_manifest\_supported\_versions) | Allowed schema versions for manifests/management-plane.yaml. | `list(number)` | <pre>[<br/>  1<br/>]</pre> | no |
| <a name="input_required_bootstrap_space_names"></a> [required\_bootstrap\_space\_names](#input\_required\_bootstrap\_space\_names) | Bootstrap spaces that must always exist in manifests/management-plane.yaml. | `list(string)` | <pre>[<br/>  "admin"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_environment_admin_spaces"></a> [environment\_admin\_spaces](#output\_environment\_admin\_spaces) | Map of environment names to their Admin space IDs. |
| <a name="output_environment_containers"></a> [environment\_containers](#output\_environment\_containers) | Map of environment names to their root container IDs. |
<!-- END_TF_DOCS -->
