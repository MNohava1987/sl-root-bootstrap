# Management Plane Operations

This document provides instructions for the routine management, scaling, and validation of the high-assurance foundation.

## Manifest Management

The environment hierarchy is driven by `manifests/topology/management-plane.yaml`.

### Adding an Environment:
To provision a new environment container and its associated orchestrator:
1. Add a new entry to the `environments` list in the manifest.
2. Define the `assurance_tier` (e.g., `tier-2` for critical, `tier-3` for standard).
3. Commit and push the change to `main`.

### Adding Sub-Spaces:
To add a new sub-space (e.g., `audit`, `networking`) to **every** environment:
1. Add the space name and description to the `bootstrap_spaces` list in the manifest.
2. Apply the change via the `sl-root-mgmt-bootstrap` stack.


## Manifest Groups

- Topology: `manifests/topology/management-plane.yaml`
- RBAC catalog: `manifests/rbac/role-catalog.yaml`

Bootstrap and naming behavior are intentionally variable-driven to keep repave operations simpler and reduce config sprawl.

## CLI Operations

### Authentication
Ensure your environment is configured with valid API credentials:
```bash
export SPACELIFT_API_KEY_ENDPOINT="https://your-account.spacelift.io"
export TF_VAR_spacelift_api_key_id="..."
export TF_VAR_spacelift_api_key_secret="..."
```

### Local Validation (Zero-Commit)
Before committing changes, use `spacectl` to run a preview plan on Spacelift workers:
`spacectl stack local-preview --id sl-root-mgmt-bootstrap`

You can also run the local assurance gate from this repo root:
`scripts/assurance-gate.sh`

### Automated Quality Gates
Every run executes the following automated checks before the plan phase:
1. `terraform fmt`: Checks for proper HCL formatting.
2. `terraform validate`: Validates HCL syntax and provider schema.
3. Manifest contract validation through Terraform `check` blocks at plan time.
4. `opa test`: Executes recursive unit tests for Rego policies under `policies/`.

By default, seed policy tests under `https://github.com/MNohava1987/sl-root-bootstrap-seed/policies/` are excluded from the root assurance gate. To include them, set:
`INCLUDE_SEED_POLICY_TESTS=true`.

## Repave Safety Model

- Default posture: `enable_deletion_protection=true`, `repave_mode=false`.
- Controlled teardown posture: set `repave_mode=true` and then set `enable_deletion_protection=false`.
- Terraform checks block accidental destructive posture changes unless repave mode is explicitly enabled.
