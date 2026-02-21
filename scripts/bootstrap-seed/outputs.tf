output "bootstrap_stack_id" {
  description = "The ID of the foundational sl-root-bootstrap stack."
  value       = spacelift_stack.bootstrap.id
}

output "space_admin_role_id" {
  description = "The dynamically resolved ULID for the Space Admin role."
  value       = data.spacelift_role.space_admin.id
}

output "vcs_integration_id" {
  description = "The ID of the VCS integration linked to the bootstrap stack."
  value       = data.spacelift_github_enterprise_integration.target.id
}

output "management_url" {
  description = "Clickable link to manage the new stack in the Spacelift UI."
  value       = "https://mnohava1987.app.us.spacelift.io/stack/${spacelift_stack.bootstrap.id}"
}
