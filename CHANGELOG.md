# Changelog

All notable changes to the Spacelift Root Bootstrap project will be documented in this file.

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
