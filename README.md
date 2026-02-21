# Spacelift Root Bootstrap (Tier 0)

This repository serves as the "Founder" for the entire Spacelift management plane. It follows a high-assurance, environment-templated pattern to initialize the foundation of a Spacelift account.

## Purpose

The bootstrap stack is the first automated layer of the management plane. Its primary responsibilities are:
1. Creating the top-level Environment Containers (Spaces) defined in the manifest.
2. Establishing isolated Constitutional Law (Rego policies) within each environment.
3. Deploying the Tier 1 Orchestrator stacks (admin-stacks) into each environment to handle downstream platform resources.

## Architecture: Cellular Isolation

This project implements a cellular architecture where each environment (e.g., Live, Test) is a self-contained unit. 
Each environment "cell" owns its own:
- Top-level Space.
- Sub-spaces for administrative, security, and shared services functions.
- Local governance policies (Git Flow, Branch Guards, Approvals) attached at the environment root.

This ensures that one environment's management plane is logically and operationally decoupled from others, providing a high degree of isolation and security.

## Governance and Assurance Levels

The management plane uses functional labeling to enforce tiered governance across all stacks.

### Assurance Tiers

The system uses a tiered model to categorize stacks and apply appropriate guardrails:

- **Tier 0 (Root/Bootstrap)**: The foundational identity and root governance. Managed by the initial seed process. These stacks have organization-wide permissions and require the strictest approval workflows.
- **Tier 1 (Orchestrators)**: Stacks that manage the management plane for specific environments. Created and managed by the Tier 0 bootstrap stack. These orchestrators own the environment-level spaces and policies.
- **Tier 2 (Critical Workloads)**: High-assurance environment workloads (e.g., Production, Live). These are governed by strict main-only git flows and require manual confirmation for all applies.
- **Tier 3+ (Standard Workloads)**: Development, testing, or sandbox environments. These may have relaxed governance, such as allowing deployments from non-main branches or auto-deployments.

### Mandatory Labels

Policies utilize the following labels to determine the "Law of the Land":

- `stack-type:management`: Identifies stacks that manage the platform itself. Triggers strict Git Flow policies (Main-branch only deployments).
- `assurance:tier-X`: Categorizes the stack into one of the tiers defined above. This is used by approval policies to determine if a run requires explicit confirmation.
- `governance:env-guard`: Triggers branch-to-environment matching policies to ensure, for example, that only the `main` branch can be applied to `Tier 2` environments.

## Management Manifest

The hierarchy is driven entirely by `manifests/management-plane.yaml`. Scaling the management plane to a new environment is performed by adding an entry to the `environments` list and defining its `assurance_tier`.

## Setup and Operation

1. **Establishing the Identity**: The initial `sl-root-bootstrap` stack must be established locally via the bootstrap-seed process.
2. **Multi-Environment Cascade**: Once the bootstrap stack is live, it autonomously manages the environments defined in the manifest.

For detailed instructions on the initial seeding process, see `scripts/bootstrap-seed/README.md`.
