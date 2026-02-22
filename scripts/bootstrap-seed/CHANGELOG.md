# Changelog

All notable changes to the Spacelift Zero-Click Bootstrap Seed will be documented in this file.

## [1.2.0] - 2026-02-22
### Added
- Seed manifest support in `scripts/bootstrap-seed/manifests/bootstrap/bootstrap-config.yaml`.
- Seed manifest loader and schema check in `scripts/bootstrap-seed/manifests.tf`.
- Manifest-driven stack branch control with `bootstrap_stack_branch`.

### Changed
- Seed stack and root policy names now resolve from manifest naming tokens with variable fallback.
- Seed README updated to make manifest-first configuration the default path.
- Terraform comments aligned to docs tone with short operational wording.

### Fixed
- Root policy package naming compatibility by using `package spacelift`.
- Stronger danger wording on deletion-protection controls.

## [1.1.0] - 2026-02-21
### Added
- Functional Labeling: Applied `stack-type:management` and `assurance:tier-0` to the bootstrap identity.
- Explicit `Space Admin` role resolution using the modern `space-admin` slug.
- Automated `terraform-docs` marker injection for high-assurance transparency.

## [1.0.0] - 2026-02-21
### Added
- Initial Zero-Click bootstrap logic using local Terraform.
- Professional multi-file structure (main, data, variables, outputs).
- Prerequisite guide and Mermaid workflow.
