# --- RESOURCE CREATION ---

# Create the foundational identity
resource "spacelift_stack" "bootstrap" {
  name        = "sl-root-bootstrap"
  repository  = "sl-root-bootstrap"
  branch      = "main"
  space_id    = "root"
  description = "Foundational Bootstrap Stack (Locally Seeded - High Assurance)"

  github_enterprise {
    id        = data.spacelift_github_enterprise_integration.target.id
    namespace = var.vcs_namespace
  }

  # --- GOVERNANCE LABELS ---
  # These enable the global policies we defined in the bootstrap repo.
  labels = ["governance:global-flow"]

  protect_from_deletion = true
  enable_local_preview  = true
  autodeploy            = false 
}

# Grant the identity its power
resource "spacelift_role_attachment" "bootstrap_admin" {
  space_id = "root"
  stack_id = spacelift_stack.bootstrap.id
  role_id  = data.spacelift_role.space_admin.id
}
