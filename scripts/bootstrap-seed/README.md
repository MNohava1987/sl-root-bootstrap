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

### 1. Update Seed Manifest (Preferred)
Open `manifests/bootstrap/bootstrap-config.yaml` and update values to match your environment:
- `bootstrap.bootstrap_stack_repository`
- `bootstrap.bootstrap_stack_branch`
- `naming.org`, `naming.env`, `naming.domain`
- `naming.function_bootstrap`, `naming.function_policy_git_flow`, `naming.function_policy_approval_law`

### 2. Update Static Variables (Fallback)
Open `variables.tf` in this directory and update default values only if you are not using manifest overrides:
- `spacelift_api_key_endpoint`: The full URL of your Spacelift account.
- `vcs_namespace`: Your GitHub organization or username.
- `vcs_integration_slug`: The name/slug of the VCS integration you created in Phase 1.
- Naming tokens for Tier-0 resources: `naming_org`, `naming_env`, `naming_domain`.

### 3. Set Sensitive Environment Variables
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

1. Root Space Governance: Two root policies named from `<org>-<env>-<domain>-<function>` will be present in the root space. These enforce main-branch-only deployments and manual approval for bootstrap changes.
2. Foundational Stack: A Tier-0 bootstrap stack named from `<org>-<env>-<domain>-<function>` will be created in the root space.
3. Permission Grant: A Space Admin role attachment will be assigned to the bootstrap stack, granting it the power to autonomously build the rest of your organization.

## Next Steps

Once this seed process is complete, you no longer need to manage resources locally. Navigate to the seeded bootstrap stack in the Spacelift UI and trigger a deployment to begin the multi-environment cascade.

## TF Docs

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_spacelift"></a> [spacelift](#requirement\_spacelift) | ~> 1.44 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_spacelift"></a> [spacelift](#provider\_spacelift) | 1.44.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [spacelift_policy.root_approval](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/policy) | resource |
| [spacelift_policy.root_push_flow](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/policy) | resource |
| [spacelift_role_attachment.bootstrap_admin](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/role_attachment) | resource |
| [spacelift_stack.bootstrap](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/stack) | resource |
| [spacelift_github_enterprise_integration.target](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/data-sources/github_enterprise_integration) | data source |
| [spacelift_role.space_admin](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/data-sources/role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bootstrap_stack_repository"></a> [bootstrap\_stack\_repository](#input\_bootstrap\_stack\_repository) | VCS repository used by the seeded bootstrap stack. | `string` | `"sl-root-bootstrap"` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | !!!!! DO NOT CHANGE THIS IF YOU DO NOT WANT THINGS TO GET DELETED !!!!!! | `bool` | `true` | no |
| <a name="input_naming_domain"></a> [naming\_domain](#input\_naming\_domain) | Domain token used by the naming convention. | `string` | `"mgmt"` | no |
| <a name="input_naming_env"></a> [naming\_env](#input\_naming\_env) | Environment token used by the naming convention for seed resources. | `string` | `"root"` | no |
| <a name="input_naming_function_bootstrap"></a> [naming\_function\_bootstrap](#input\_naming\_function\_bootstrap) | Function token for the Tier-0 bootstrap stack. | `string` | `"bootstrap"` | no |
| <a name="input_naming_function_policy_approval_law"></a> [naming\_function\_policy\_approval\_law](#input\_naming\_function\_policy\_approval\_law) | Function token for the root approval policy. | `string` | `"approval-law"` | no |
| <a name="input_naming_function_policy_git_flow"></a> [naming\_function\_policy\_git\_flow](#input\_naming\_function\_policy\_git\_flow) | Function token for the root git-flow policy. | `string` | `"git-flow"` | no |
| <a name="input_naming_org"></a> [naming\_org](#input\_naming\_org) | Organization token used by the naming convention. | `string` | `"sl"` | no |
| <a name="input_spacelift_api_key_endpoint"></a> [spacelift\_api\_key\_endpoint](#input\_spacelift\_api\_key\_endpoint) | The URL of your Spacelift account | `string` | `"https://mnohava1987.app.us.spacelift.io"` | no |
| <a name="input_spacelift_api_key_id"></a> [spacelift\_api\_key\_id](#input\_spacelift\_api\_key\_id) | Spacelift API Key ID with Admin permissions | `string` | n/a | yes |
| <a name="input_spacelift_api_key_secret"></a> [spacelift\_api\_key\_secret](#input\_spacelift\_api\_key\_secret) | Spacelift API Key Secret | `string` | n/a | yes |
| <a name="input_vcs_integration_slug"></a> [vcs\_integration\_slug](#input\_vcs\_integration\_slug) | The human-readable name of your VCS integration | `string` | `"sl-github-vcs-integration"` | no |
| <a name="input_vcs_namespace"></a> [vcs\_namespace](#input\_vcs\_namespace) | Your GitHub Organization or ADO Project | `string` | `"MNohava1987"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bootstrap_stack_id"></a> [bootstrap\_stack\_id](#output\_bootstrap\_stack\_id) | The ID of the foundational Tier-0 bootstrap stack. |
| <a name="output_management_url"></a> [management\_url](#output\_management\_url) | Clickable link to manage the new stack in the Spacelift UI. |
| <a name="output_space_admin_role_id"></a> [space\_admin\_role\_id](#output\_space\_admin\_role\_id) | The dynamically resolved ULID for the Space Admin role. |
| <a name="output_vcs_integration_id"></a> [vcs\_integration\_id](#output\_vcs\_integration\_id) | The ID of the VCS integration linked to the bootstrap stack. |
<!-- END_TF_DOCS -->
