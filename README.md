# Spacelift Root Bootstrap

This repository serves as the "Seed" for the entire Spacelift management plane. It follows the "Stack-of-Stacks" pattern to initialize the foundational administrative structure of your Spacelift account.

## Overview

The bootstrap process performs two primary actions:
1. Creates the **Admin Space**: An isolated control plane for administrative resources.
2. Creates the **Admin Stacks Orchestrator**: A dedicated stack that manages all downstream infrastructure (Platform Spaces, Modules, and Policies).

> [!IMPORTANT]
> **Administrative Permissions Required**
>
> This stack manages account-wide resources (Spaces, Stacks, and Policies). To function correctly, it must be granted elevated permissions:
> 1. **Administrative Toggle**: Located in the stack's **Settings -> Behavior** tab. This must be set to **ON**.
> 2. **RBAC Role**: Grant this stack the **Space Admin** role on the **root** space via the Spaces UI.
>
> *Note: While the Administrative toggle is currently being deprecated in favor of RBAC roles, both should be applied for maximum compatibility during the transition period.*

## Repository Structure

```text
.
├── .spacelift/          # Spacelift-specific configuration and hooks
├── docs/                # Detailed guides for setup and recovery
├── scripts/             # Automation utilities for bootstrapping and repaving
├── main.tf              # Primary infrastructure definitions
├── variables.tf         # Input definitions with modern HCL formatting
├── providers.tf         # Provider configuration
└── versions.tf          # Version constraints for Terraform and Spacelift
```

## Getting Started

To initialize or recover this environment, please refer to the documentation:

1. **New Account Setup**: See [docs/scaffolding.md](docs/scaffolding.md) for the initial CLI/UI requirements.
2. **Standard Recovery**: See [docs/repave-guide.md](docs/repave-guide.md) for instructions on using the automated recovery script.

## Automation

The project includes a `scripts/repave.sh` utility designed to automate variable injection and deployment triggers once the initial stack shell is established.

## Governance

This project implements modern Spacelift RBAC. All administrative actions are governed by explicit Space Roles, ensuring a secure and auditable management plane.
