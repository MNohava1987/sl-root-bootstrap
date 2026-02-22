# Naming Standard

This repository uses a unified naming convention for platform entities:
`<org>-<env>-<domain>-<function>`

Source of truth: naming variables in `variables.tf` and contract checks in `checks.tf`.

Custom roles use a role-specific variant:
`<org>-<domain>-role-<profile>`

## Token Catalog

- `org`: platform short code, lowercase kebab-case, 2-10 chars.
  - Example: `sl`
- `env`: environment token.
  - Recommended set: `live`, `prod`, `stage`, `test`, `dev`, `sandbox`
- `domain`: capability boundary.
  - Allowed set: `mgmt`, `network`, `security`, `identity`, `data`, `app`, `observability`, `shared`
- `function`: role-specific capability name.
  - Examples: `admin-stacks-orchestrator`, `env-root-space`, `git-flow`, `branch-guard`, `approval-law`, `role`
- `profile`: role profile token (for custom roles only).
  - Examples: `stack-manager`, `space-manager`, `policy-manager`, `readonly-auditor`

## Rules

- Lowercase kebab-case only.
- Regex: `^[a-z0-9]+(-[a-z0-9]+)*$`
- Tier is not part of names. Tier stays in labels (`assurance:tier-X`).
- Keep names stable. Mutable metadata belongs in labels.

## Examples

- Stack: `sl-live-mgmt-admin-stacks-orchestrator`
- Environment space: `sl-live-mgmt-env-root-space`
- Policy: `sl-live-mgmt-git-flow`
- Context: `sl-live-shared-global-vars`
- Custom role: `sl-mgmt-role-stack-manager`

## Enforcement in Terraform

Naming validation is implemented in `checks.tf` and controlled by variables in `variables.tf`.

Transition strategy:
- Keep strict regex and length checks enabled.
- Keep allow-list checks optional while migrating legacy names.
- Enable hard catalog checks once all environments/domains/functions are normalized.

## Current Enforcement Knobs

- `naming_org`
- `naming_domain`
- `naming_function_admin_stacks`
- `naming_function_env_root_space`
- `naming_function_policy_git_flow`
- `naming_function_policy_branch_guard`
- `naming_function_policy_approval_law`
- `naming_function_role_prefix`
- `naming_token_regex`
- `naming_max_length`
- `naming_enforce_allowed_envs`
- `allowed_env_tokens`
- `naming_enforce_allowed_domains`
- `allowed_domain_tokens`
- `naming_enforce_allowed_functions`
- `allowed_function_tokens`
- `naming_enforce_allowed_role_profiles`
- `allowed_role_profile_tokens`
