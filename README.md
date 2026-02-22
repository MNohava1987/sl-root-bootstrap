# Spacelift Root Bootstrap (Tier 0)

This repository serves as the "Founder" for the entire Spacelift management plane. It follows a high-assurance, environment-templated pattern to initialize the foundation of a Spacelift account.

## Overview

The bootstrap stack is the first automated layer of the organization. It autonomously creates top-level environment containers, establishes local governance, and deploys the Tier 1 orchestrator stacks required for downstream management.

## Technical Library

Detailed documentation is organized by functional area in the `docs/` directory:

- **[Architecture Blueprint](docs/architecture.md)**: Cellular isolation, assurance tiering, and logical hierarchy.
- **[Operations Manual](docs/operations.md)**: Manifest management, CLI usage, and validation gates.
- **[Naming Standard](docs/naming-standard.md)**: Token catalog and enforcement rules for resource naming.
- **[Recovery Manifesto](docs/recovery.md)**: Definitive step-by-step instructions for Nuke and Pave operations.
- **[Bootstrap Seed Guide](scripts/bootstrap-seed/README.md)**: Instructions for the local "Bootloader" setup.

## Quick Start

1. **Seeding**: Initialize the foundational identity and root policies via the [Bootstrap Seed process](scripts/bootstrap-seed/README.md).
2. **Handoff**: Trigger the `sl-root-mgmt-bootstrap` stack in the Spacelift UI to build the multi-environment cascade defined in `manifests/topology/management-plane.yaml`.
3. **Validation**: Use `local-preview` via `spacectl` to verify changes before merging to `main`.

## Maintenance

The management plane is manifest-driven with grouped catalogs under `manifests/`:
- `manifests/topology/management-plane.yaml`
- `manifests/bootstrap/bootstrap-config.yaml`
- `manifests/governance/naming-catalog.yaml`
- `manifests/rbac/role-catalog.yaml`

RBAC profile ownership is managed in bootstrap:
- Custom roles are created in `rbac.tf` when `enable_custom_role_profiles=true`.
- Downstream repos consume `role_profile_role_slugs` and `role_catalog` outputs.
- Guardrails in `checks.tf` prevent non-admin profiles from silently remaining `space-admin` unless explicitly allowed.

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
| [spacelift_role.profile](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/role) | resource |
| [spacelift_role_attachment.admin_stacks](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/role_attachment) | resource |
| [spacelift_space.env_root](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/space) | resource |
| [spacelift_space.env_sub_space](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/space) | resource |
| [spacelift_stack.admin_stacks](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/stack) | resource |
| [spacelift_role.role_by_slug](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/data-sources/role) | data source |
| [spacelift_role.space_admin](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/data-sources/role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_space_id"></a> [admin\_space\_id](#input\_admin\_space\_id) | The parent space for environment containers | `string` | `"root"` | no |
| <a name="input_admin_stacks_branch"></a> [admin\_stacks\_branch](#input\_admin\_stacks\_branch) | n/a | `string` | `"main"` | no |
| <a name="input_admin_stacks_repo"></a> [admin\_stacks\_repo](#input\_admin\_stacks\_repo) | n/a | `string` | `"sl-admin-stacks"` | no |
| <a name="input_allow_space_admin_in_custom_profiles"></a> [allow\_space\_admin\_in\_custom\_profiles](#input\_allow\_space\_admin\_in\_custom\_profiles) | When false, custom role profiles cannot include SPACE\_ADMIN in role\_profile\_actions. | `bool` | `false` | no |
| <a name="input_allowed_assurance_tiers"></a> [allowed\_assurance\_tiers](#input\_allowed\_assurance\_tiers) | Allowed assurance\_tier values for environments in the management manifest. | `list(string)` | <pre>[<br/>  "tier-0",<br/>  "tier-1",<br/>  "tier-2",<br/>  "tier-3",<br/>  "tier-10"<br/>]</pre> | no |
| <a name="input_allowed_domain_tokens"></a> [allowed\_domain\_tokens](#input\_allowed\_domain\_tokens) | Allow-list for domain tokens. | `list(string)` | <pre>[<br/>  "mgmt",<br/>  "network",<br/>  "security",<br/>  "identity",<br/>  "data",<br/>  "app",<br/>  "observability",<br/>  "shared"<br/>]</pre> | no |
| <a name="input_allowed_env_tokens"></a> [allowed\_env\_tokens](#input\_allowed\_env\_tokens) | Allow-list for environment tokens. | `list(string)` | <pre>[<br/>  "live",<br/>  "prod",<br/>  "stage",<br/>  "test",<br/>  "dev",<br/>  "sandbox",<br/>  "matt-test1"<br/>]</pre> | no |
| <a name="input_allowed_function_tokens"></a> [allowed\_function\_tokens](#input\_allowed\_function\_tokens) | Allow-list for function tokens. | `list(string)` | <pre>[<br/>  "admin-stacks-orchestrator",<br/>  "env-root-space",<br/>  "git-flow",<br/>  "branch-guard",<br/>  "approval-law",<br/>  "role"<br/>]</pre> | no |
| <a name="input_allowed_role_profile_tokens"></a> [allowed\_role\_profile\_tokens](#input\_allowed\_role\_profile\_tokens) | Allow-list for role profile tokens used as <profile> in custom role naming. | `list(string)` | <pre>[<br/>  "stack-manager",<br/>  "space-manager",<br/>  "policy-manager",<br/>  "readonly-auditor",<br/>  "space-admin"<br/>]</pre> | no |
| <a name="input_enable_auto_deploy"></a> [enable\_auto\_deploy](#input\_enable\_auto\_deploy) | Enables auto-deploy for the management plane orchestrators | `bool` | `false` | no |
| <a name="input_enable_custom_role_profiles"></a> [enable\_custom\_role\_profiles](#input\_enable\_custom\_role\_profiles) | When true, create custom Spacelift roles for non-admin role profiles. | `bool` | `true` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | !!!!! DO NOT CHANGE THIS IF YOU DO NOT WANT THINGS TO GET DELETED IT ALLOWS DELETION OF FOUNDATIONAL INFRA!!!!!! | `bool` | `true` | no |
| <a name="input_enforce_lowercase_environment_names"></a> [enforce\_lowercase\_environment\_names](#input\_enforce\_lowercase\_environment\_names) | When true, all environment names in the manifest must be lowercase. | `bool` | `false` | no |
| <a name="input_manifest_supported_versions"></a> [manifest\_supported\_versions](#input\_manifest\_supported\_versions) | Allowed schema versions for manifests/topology/management-plane.yaml. | `list(number)` | <pre>[<br/>  1<br/>]</pre> | no |
| <a name="input_naming_domain"></a> [naming\_domain](#input\_naming\_domain) | Domain token used by the <org>-<env>-<domain>-<function> naming convention. | `string` | `"mgmt"` | no |
| <a name="input_naming_enforce_allowed_domains"></a> [naming\_enforce\_allowed\_domains](#input\_naming\_enforce\_allowed\_domains) | When true, naming\_domain must be in allowed\_domain\_tokens. | `bool` | `true` | no |
| <a name="input_naming_enforce_allowed_envs"></a> [naming\_enforce\_allowed\_envs](#input\_naming\_enforce\_allowed\_envs) | When true, environment tokens must be in allowed\_env\_tokens. | `bool` | `false` | no |
| <a name="input_naming_enforce_allowed_functions"></a> [naming\_enforce\_allowed\_functions](#input\_naming\_enforce\_allowed\_functions) | When true, function tokens must be in allowed\_function\_tokens. | `bool` | `false` | no |
| <a name="input_naming_enforce_allowed_role_profiles"></a> [naming\_enforce\_allowed\_role\_profiles](#input\_naming\_enforce\_allowed\_role\_profiles) | When true, custom role profile tokens must be in allowed\_role\_profile\_tokens. | `bool` | `false` | no |
| <a name="input_naming_function_admin_stacks"></a> [naming\_function\_admin\_stacks](#input\_naming\_function\_admin\_stacks) | Function token for Tier-1 admin orchestrator stacks. | `string` | `"admin-stacks-orchestrator"` | no |
| <a name="input_naming_function_env_root_space"></a> [naming\_function\_env\_root\_space](#input\_naming\_function\_env\_root\_space) | Function token for top-level environment root spaces. | `string` | `"env-root-space"` | no |
| <a name="input_naming_function_policy_approval_law"></a> [naming\_function\_policy\_approval\_law](#input\_naming\_function\_policy\_approval\_law) | Function token for approval policies. | `string` | `"approval-law"` | no |
| <a name="input_naming_function_policy_branch_guard"></a> [naming\_function\_policy\_branch\_guard](#input\_naming\_function\_policy\_branch\_guard) | Function token for branch guard policies. | `string` | `"branch-guard"` | no |
| <a name="input_naming_function_policy_git_flow"></a> [naming\_function\_policy\_git\_flow](#input\_naming\_function\_policy\_git\_flow) | Function token for git-flow policies. | `string` | `"git-flow"` | no |
| <a name="input_naming_function_role_prefix"></a> [naming\_function\_role\_prefix](#input\_naming\_function\_role\_prefix) | Function token prefix used for custom role names (<org>-<domain>-role-<profile>). | `string` | `"role"` | no |
| <a name="input_naming_max_length"></a> [naming\_max\_length](#input\_naming\_max\_length) | Maximum length for generated canonical names. | `number` | `63` | no |
| <a name="input_naming_org"></a> [naming\_org](#input\_naming\_org) | Organization token used by the <org>-<env>-<domain>-<function> naming convention. | `string` | `"sl"` | no |
| <a name="input_naming_token_regex"></a> [naming\_token\_regex](#input\_naming\_token\_regex) | Regex contract for naming tokens. | `string` | `"^[a-z0-9]+(-[a-z0-9]+)*$"` | no |
| <a name="input_required_bootstrap_space_names"></a> [required\_bootstrap\_space\_names](#input\_required\_bootstrap\_space\_names) | Bootstrap spaces that must always exist in manifests/topology/management-plane.yaml. | `list(string)` | <pre>[<br/>  "admin"<br/>]</pre> | no |
| <a name="input_role_profile_actions"></a> [role\_profile\_actions](#input\_role\_profile\_actions) | Actions assigned to custom role profiles. These defaults are least-privilege first-pass mappings; validate against your account action catalog. | `map(list(string))` | <pre>{<br/>  "policy-manager": [<br/>    "SPACE_READ",<br/>    "SPACE_WRITE"<br/>  ],<br/>  "readonly-auditor": [<br/>    "SPACE_READ"<br/>  ],<br/>  "space-manager": [<br/>    "SPACE_READ",<br/>    "SPACE_WRITE"<br/>  ],<br/>  "stack-manager": [<br/>    "SPACE_READ",<br/>    "SPACE_WRITE",<br/>    "RUN_TRIGGER",<br/>    "TASK_CREATE",<br/>    "STACK_CREATE",<br/>    "STACK_UPDATE",<br/>    "STACK_DELETE",<br/>    "STACK_LOCK",<br/>    "STACK_UNLOCK",<br/>    "STACK_ADD_CONFIG",<br/>    "STACK_DELETE_CONFIG",<br/>    "STACK_SET_CURRENT_COMMIT",<br/>    "STACK_SYNC_COMMIT",<br/>    "STACK_UPLOAD_LOCAL_WORKSPACE",<br/>    "STACK_STATE_READ"<br/>  ]<br/>}</pre> | no |
| <a name="input_role_profile_role_slugs"></a> [role\_profile\_role\_slugs](#input\_role\_profile\_role\_slugs) | Baseline map of role profile names to Spacelift role slugs. Defaults map all profiles to space-admin for safe bootstrap compatibility. | `map(string)` | <pre>{<br/>  "policy-manager": "space-admin",<br/>  "readonly-auditor": "space-admin",<br/>  "space-admin": "space-admin",<br/>  "space-manager": "space-admin",<br/>  "stack-manager": "space-admin"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_environment_admin_spaces"></a> [environment\_admin\_spaces](#output\_environment\_admin\_spaces) | Map of environment names to their Admin space IDs. |
| <a name="output_environment_containers"></a> [environment\_containers](#output\_environment\_containers) | Map of environment names to their root container IDs. |
| <a name="output_role_catalog"></a> [role\_catalog](#output\_role\_catalog) | Map of role profile names to resolved Spacelift role IDs. |
| <a name="output_role_profile_role_slugs"></a> [role\_profile\_role\_slugs](#output\_role\_profile\_role\_slugs) | Map of role profile names to Spacelift role slugs used by downstream orchestrators. |
<!-- END_TF_DOCS -->
