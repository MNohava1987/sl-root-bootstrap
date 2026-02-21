# Assurance Gates

This repository enforces institutional-grade guardrails with a layered gate model.

## Gate Layers

1. Static Terraform checks:
- `terraform fmt -check -recursive`
- `terraform validate`

2. Policy checks:
- `opa test ./policies -v`
- Optional: `INCLUDE_SEED_POLICY_TESTS=true` to run `scripts/bootstrap-seed/policies` tests.

3. Contract checks (Terraform `check` blocks in `checks.tf`):
- `manifest_version` must exist and be in `manifest_supported_versions`.
- Environment names must be unique (case-insensitive).
- Allowed `assurance_tier` values enforced via `allowed_assurance_tiers`.
- Required bootstrap spaces enforced via `required_bootstrap_space_names`.
- Environment isolation and orchestrator label integrity assertions.

## Local Usage

From repository root:
`./scripts/assurance-gate.sh`

## Spacelift Usage

`.spacelift/config.yml` runs `scripts/assurance-gate.sh` in `before_plan`.

## Tuning Without Code Changes

Use stack variables to tune contract behavior:
- `manifest_supported_versions`
- `allowed_assurance_tiers`
- `required_bootstrap_space_names`
- `enforce_lowercase_environment_names`
