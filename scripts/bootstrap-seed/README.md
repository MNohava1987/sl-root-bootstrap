# Spacelift Bootstrap Seed: Initial Setup Guide

This directory contains the foundational Terraform logic required to initialize a Spacelift account from a "zero-state" (nothing created). This process establishes the initial Identity, Permissions, and Root Governance required for high-assurance management.

## Prerequisites

1. An active Spacelift account.
2. A GitHub account with administrative access to the repositories intended for management.
3. Terraform (v1.5+) installed on your local machine.

## Phase 1: Manual Configuration in Spacelift UI

Before running the automated seed, two manual connections must be established in the Spacelift web interface.

### 1. Establish VCS Integration
Spacelift requires a connection to your Version Control System to read your infrastructure code.

1. Log in to your Spacelift account.
2. Navigate to Settings in the left-hand sidebar.
3. Select Integrations.
4. Locate the GitHub section and click Set Up or Add.
5. Follow the prompts to install the Spacelift GitHub App on your organization or personal account.
6. Once established, note the Name/Slug of the integration (the default is usually "github-default" or "sl-github-vcs-integration"). You will need this for the `vcs_integration_slug` variable.

### 2. Create administrative API Key
This key is used only once to allow your local machine to communicate with Spacelift and build the initial stack.

1. In the Settings menu, select API Keys.
2. Click Create New Key.
3. Configuration:
   - Name: Bootstrap Seed Admin
   - Admin Permissions: Enabled (Must be checked)
4. Click Create.
5. Critical: Copy the API Key ID and API Key Secret immediately. The secret is only displayed once.

## Phase 2: Configuration

### 1. Update Static Variables
Open `variables.tf` in this directory and update the following default values to match your environment:
- `spacelift_api_key_endpoint`: The full URL of your Spacelift account.
- `vcs_namespace`: Your GitHub organization or username.
- `vcs_integration_slug`: The name/slug of the VCS integration you created in Phase 1.

### 2. Set Sensitive Environment Variables
Set the following environment variables in your local terminal to allow Terraform to authenticate using the API key created in Phase 1.

```bash
export TF_VAR_spacelift_api_key_id="your-key-id"
export TF_VAR_spacelift_api_key_secret="your-key-secret"
```

## Phase 3: Execution

1. Initialize Terraform:
   `terraform init`
2. Review the execution plan:
   `terraform plan`
3. Apply the configuration:
   `terraform apply`

## Phase 4: Verification

Upon successful completion, the following resources will exist in your Spacelift account:

1. Root Space Governance: Two policies (root-git-flow and root-approval-law) will be present in the root space. These enforce main-branch-only deployments and manual approval for the bootstrap process.
2. Foundational Stack: A stack named "sl-root-bootstrap" will be created in the root space.
3. Permission Grant: A Space Admin role attachment will be assigned to the sl-root-bootstrap stack, granting it the power to autonomously build the rest of your organization.

## Next Steps

Once this seed process is complete, you no longer need to manage resources locally. Navigate to the sl-root-bootstrap stack in the Spacelift UI and trigger a deployment to begin the multi-environment cascade.
