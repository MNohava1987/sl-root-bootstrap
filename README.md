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
