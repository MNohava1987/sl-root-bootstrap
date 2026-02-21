# Spacelift Zero-Click Bootstrap Seed

This directory contains the "Bootloader" logic for a Spacelift account. Its only purpose is to establish the initial **Identity** and **Permissions** required for the account to manage itself.

## Workflow

:::mermaid
graph TD
    A[Manual: VCS Integration] --> B[Manual: Admin API Key]
    B --> C[Local: terraform apply]
    C --> D[Created: sl-root-bootstrap Stack]
    C --> E[Assigned: Space Admin Role]
    D --> F[Handoff: Management Plane Cascade]
:::

## Mandatory Manual Dependencies
Before running this seed, you must perform the following actions in the Spacelift UI:

1. **VCS Integration**: 
   - Navigate to `Settings -> Integrations`.
   - Setup your VCS (e.g., GitHub App).
   - Note the **Slug/Name** (e.g., `sl-github-vcs-integration`).
2. **Admin API Key**:
   - Navigate to `Settings -> API Keys`.
   - Create a key with **Admin** permissions.
   - Note the **ID** and **Secret**.

## Usage

1. **Set Environment Variables**:
   ```bash
   export TF_VAR_spacelift_api_key_id="your-id"
   export TF_VAR_spacelift_api_key_secret="your-secret"
   ```

2. **Configure local variables**:
   Ensure the `vcs_integration_slug` and `vcs_namespace` in `variables.tf` match your environment.

3. **Initialize and Seed**:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```

## Outcomes
Successful execution establishes:
- The foundational **`sl-root-bootstrap`** stack shell in the `root` space.
- A **`Space Admin`** RBAC role attachment assigned to that stack.
- Security hardening (Deletion protection and Local Preview enabled).

---

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
| [spacelift_role_attachment.bootstrap_admin](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/role_attachment) | resource |
| [spacelift_stack.bootstrap](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/stack) | resource |
| [spacelift_github_enterprise_integration.target](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/data-sources/github_enterprise_integration) | data source |
| [spacelift_role.space_admin](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/data-sources/role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_spacelift_api_key_endpoint"></a> [spacelift\_api\_key\_endpoint](#input\_spacelift\_api\_key\_endpoint) | The URL of your Spacelift account | `string` | `"https://mnohava1987.app.us.spacelift.io"` | no |
| <a name="input_spacelift_api_key_id"></a> [spacelift\_api\_key\_id](#input\_spacelift\_api\_key\_id) | Spacelift API Key ID with Admin permissions | `string` | n/a | yes |
| <a name="input_spacelift_api_key_secret"></a> [spacelift\_api\_key\_secret](#input\_spacelift\_api\_key\_secret) | Spacelift API Key Secret | `string` | n/a | yes |
| <a name="input_vcs_integration_slug"></a> [vcs\_integration\_slug](#input\_vcs\_integration\_slug) | The human-readable name of your VCS integration | `string` | `"sl-github-vcs-integration"` | no |
| <a name="input_vcs_namespace"></a> [vcs\_namespace](#input\_vcs\_namespace) | Your GitHub Organization or ADO Project | `string` | `"MNohava1987"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bootstrap_stack_id"></a> [bootstrap\_stack\_id](#output\_bootstrap\_stack\_id) | The ID of the foundational sl-root-bootstrap stack. |
| <a name="output_management_url"></a> [management\_url](#output\_management\_url) | Clickable link to manage the new stack in the Spacelift UI. |
| <a name="output_space_admin_role_id"></a> [space\_admin\_role\_id](#output\_space\_admin\_role\_id) | The dynamically resolved ULID for the Space Admin role. |
| <a name="output_vcs_integration_id"></a> [vcs\_integration\_id](#output\_vcs\_integration\_id) | The ID of the VCS integration linked to the bootstrap stack. |
<!-- END_TF_DOCS -->
