# Spacelift Zero-Click Bootstrap Seed

This directory contains the foundational logic to initialize a Spacelift account from zero.

## Mandatory Manual Dependencies
Before running this seed, you MUST perform the following actions in the Spacelift UI:

1. **VCS Integration**: 
   - Navigate to `Settings -> Integrations`.
   - Setup either **GitHub** or **Azure DevOps**.
   - Note the **Integration ID** (e.g., `sl-github-...` or `my-ado-link`).
2. **Admin API Key**:
   - Navigate to `Settings -> API Keys`.
   - Create a key with **Admin** permissions.
   - Note the **ID** and **Secret**.

## Automated Seeding
Once the above is done, this script handles the rest:
- Creating the `sl-root-bootstrap` identity.
- Assigning the `Space Admin` role.
- Hardening the stack security settings.

## Usage
```bash
export SPACELIFT_API_KEY_ENDPOINT="https://..."
export SPACELIFT_API_KEY_ID="..."
export SPACELIFT_API_KEY_SECRET="..."
export TF_VAR_vcs_integration_id="your-integration-id"

terraform init
terraform apply -auto-approve
```
