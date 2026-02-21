# Spacelift Root Bootstrap (Tier 0)

This repository serves as the "Founder" for the entire Spacelift management plane. It follows a high-assurance, environment-templated pattern to initialize the foundation of your Spacelift account.

## Overview

The bootstrap process performs the following for each environment defined in `manifests/environments.yaml`:
1. **Environment Container**: Creates a top-level isolated space (e.g., `Prod`).
2. **Constitutional Law**: Attaches account-wide Git Flow and Environment Guard policies directly to the environment root.
3. **The Brain**: Spawns an `admin-stacks` orchestrator stack inside a dedicated `Admin` sub-space.

## High Assurance Features

- **Keyless Authentication**: Uses Spacelift Runtime Tokens and RBAC Roles instead of static API keys.
- **Environment Templating**: Scale your management plane by adding environments to a simple YAML list.
- **Policy Inheritance**: Governance is enforced at the environment root, ensuring all child stacks comply with organizational standards.

## Repository Structure

```text
.
├── .spacelift/          # Quality gates and validation hooks
├── manifests/           # Environment registry (YAML)
├── policies/            # Constitutional Rego policies
├── scripts/             # Local seed and repave utilities
├── main.tf              # Multi-environment foundation logic
├── variables.tf         # Global configuration inputs
├── providers.tf         # Keyless runtime provider config
├── outputs.tf           # Environment status and space IDs
└── versions.tf          # Provider constraints
```

## Setup & Recovery

1. **Initial Seed**: See [scripts/bootstrap-seed/README.md](scripts/bootstrap-seed/README.md) to establish the first identity via code.
2. **Full Restoration**: Once the seed stack is live, trigger a deployment to rebuild the entire multi-tier hierarchy.

---

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
