# Changelog

All notable changes to the Spacelift Root Bootstrap project will be documented in this file.

### Enhancement Opportunities
- **API Race Condition**: During full destruction, the Spacelift API may return a success signal for stack deletion while internal references are still clearing. This can cause parent space deletion to fail on the first attempt. 
    - **Future Resolution Strategy**: Implementation of a polling provisioner or CI/CD level retry is recommended to handle the eventually consistent nature of the Spacelift backend without introducing artificial sleeps.
- **Automated Policy Enforcement (Git/Spacelift Hooks)**: Implement automated `opa test` execution at the commit level (Git Pre-Commit Hooks) and planning level (Spacelift Pre-Plan Hooks).
    - **Future Resolution Strategy**: Update `.spacelift/config.yml` to download the OPA binary and execute recursive unit tests as a mandatory quality gate before every Terraform plan.

## [1.1.0] - 2026-02-21
### Added
- High-Assurance "Cellular" Architecture: Each environment (Live, Test) is now an isolated unit with its own local governance and spaces.
- Tiered Governance Model: Implemented Tier 0 (Root), Tier 1 (Orchestrator), and Tier 2 (Critical Workload) categorization.
- Recursive Testing Framework: Implemented 13 Rego unit tests covering Seed and Environment layers with 100% pass rate.
- Package Isolation: Implemented unique Rego namespaces (`spacelift.seed`, `spacelift.env`) to prevent policy pollution.
- Standardized functional labeling for automated policy enforcement (`assurance:tier-X`, `stack-type:management`).
- Deletion Protection Toggle: Global `enable_deletion_protection` variable added to Seed and Main layers for safety.
- Zero-Setup VCS: Orchestrator stacks now autonomously utilize the account's default GitHub integration.
- Dynamic Manifesting: Environments and sub-spaces are now fully driven by `manifests/management-plane.yaml`.
- Robust Null-Safety: Implemented dual-safety checks in `main.tf` to handle empty or commented-out manifests.
- Definitive Repave Guide: Comprehensive step-by-step documentation for full organization restoration.

### Fixed
- Policy Redundancy: Decentralized policies from root to environment spaces for sovereign isolation.
- Role Resolution: Fixed `spacelift_role` data source to use `slug = "space-admin"` for dynamic ULID lookup.
- Rego Parsing: Resolved conflict in `branch-env-guard` by migrating to Rego v1 `contains` syntax.
- Keyed Label Parsing: Updated all policies to correctly handle Spacelift's list-based keyed labels.
- Slug Conflicts: Implemented environment-prefixing for resources to prevent account-wide name collisions.

---

## [1.0.0] - 2026-02-20
### Added
- Initial project structure following DevOps best practices.
- Automated repave script in `scripts/`.
- Comprehensive documentation in `docs/` for RBAC and Scaffolding.
- Spacelift configuration for automated code quality checks.
- Support for modern Spacelift Provider (v1.44.0+).

### Fixed
- Corrected attribute names for `spacelift_space` (`parent_space_id` and `id`).
- Resolved schema validation errors for `terraform_workflow_tool`.
- Fixed VCS integration mapping for standard GitHub App integrations.
- Standardized HCL formatting in `variables.tf`.
