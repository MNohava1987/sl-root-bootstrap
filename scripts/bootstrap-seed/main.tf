# Tier 0 Governance: Define seeded policy that helps protect/govern the root stack. This should NOT grow much past this...)
# Policies defined in 'root' automatically govern the root space and all its children.
resource "spacelift_policy" "root_push_flow" {
  name        = "root-git-flow"
  type        = "GIT_PUSH"
  body        = file("${path.module}/../../policies/push/global_flow.rego")
  description = "Tier 0 Governance: Enforces main-only deployments for the bootstrap stack."
  space_id    = "root"
}

resource "spacelift_policy" "root_approval" {
  name        = "root-approval-law"
  type        = "APPROVAL"
  body        = file("${path.module}/../../policies/approval/global_approval.rego")
  description = "Tier 0 Governance: Requires approval for bootstrap changes."
  space_id    = "root"
}

# Create the foundational stack in root to run bootstrap
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

