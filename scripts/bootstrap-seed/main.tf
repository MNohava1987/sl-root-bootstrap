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

  # --- FUNCTIONAL LABELS ---
  # These identify the stack's role and its assurance tier.
  # Policies use these to determine the 'Law of the Land'.
  labels = [
    "stack-type:management", # Enforces main-only git-flow
    "assurance:tier-0"       # Enforces strict approval requirements
  ]

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
