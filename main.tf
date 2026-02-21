# --- 1) ACCOUNT-WIDE POLICIES (THE CONSTITUTION) ---

# Global Push Policy: Enforces main-only deploys and auto-cleans duplicates.
resource "spacelift_policy" "global_push_flow" {
  name        = "global-git-flow"
  type        = "GIT_PUSH"
  body        = file("${path.module}/policies/push/global_flow.rego")
  description = "Enforces main-only deployments and auto-discards redundant queued runs."
  space_id    = "root"
}

# Explicit attachment to the Root Space ensures global inheritance.
resource "spacelift_policy_attachment" "bootstrap_push" {
  policy_id = spacelift_policy.global_push_flow.id
  stack_id  = "sl-root-bootstrap"
}

# Environment Guard: Ensures branch names match stack environment labels.
resource "spacelift_policy" "branch_env" {
  name        = "branch-env-guard"
  type        = "PLAN"
  body        = file("${path.module}/policies/branch_env.rego")
  description = "Blocks apply if the VCS branch does not match the stack environment label."
  space_id    = "root"
}

# Global Approval Policy: Requires explicit approval for critical changes.
resource "spacelift_policy" "global_approval" {
  name        = "global-approval-law"
  type        = "APPROVAL"
  body        = file("${path.module}/policies/approval/global_approval.rego")
  description = "Requires approval for administrative stacks and production environments."
  space_id    = "root"
}

# Attach Approval to Management Stacks (to ensure Tier 1 review)
resource "spacelift_policy_attachment" "orchestrator_approval" {
  policy_id = spacelift_policy.global_approval.id
  stack_id  = spacelift_stack.admin_stacks.id
}

resource "spacelift_policy_attachment" "sandbox_orchestrator_approval" {
  policy_id = spacelift_policy.global_approval.id
  stack_id  = spacelift_stack.sandbox_admin_stacks.id
}

# --- 2) ADMIN CONTROL PLANE ---

# Admin space (Production Management)
resource "spacelift_space" "admin" {
  parent_space_id = var.admin_space_id
  name            = "Admin"
  description     = "Production administrative control plane"
  inherit_entities = true
}

# Spacelift Sandbox (Testing the Management Plane)
resource "spacelift_space" "sandbox" {
  parent_space_id = spacelift_space.admin.id
  name            = "Spacelift Sandbox"
  description     = "Isolated space for testing management plane changes (SoS)"
  inherit_entities = true
}

# Admin-stacks stack (The Production Orchestrator)
resource "spacelift_stack" "admin_stacks" {
  name        = "admin-stacks"
  description = "Production Orchestrator for administrative stacks"
  space_id    = spacelift_space.admin.id

  repository   = var.admin_stacks_repo
  branch       = var.admin_stacks_branch
  project_root = "/"

  autodeploy           = var.enable_auto_deploy
  administrative       = true
  enable_local_preview = true
}

# Sandbox-admin-stacks (The Testing Orchestrator)
resource "spacelift_stack" "sandbox_admin_stacks" {
  name        = "sandbox-admin-stacks"
  description = "Experimental Orchestrator for testing management plane changes"
  space_id    = spacelift_space.sandbox.id

  repository   = var.admin_stacks_repo
  branch       = "develop" # We use develop here to test changes before merging to main
  project_root = "/"

  autodeploy           = var.enable_auto_deploy
  administrative       = true
  enable_local_preview = true
}

# --- 3) OUTPUTS ---

output "admin_space_id" {
  value = spacelift_space.admin.id
}

output "sandbox_space_id" {
  value = spacelift_space.sandbox.id
}

output "admin_stacks_stack_id" {
  value = spacelift_stack.admin_stacks.id
}

output "sandbox_stacks_stack_id" {
  value = spacelift_stack.sandbox_admin_stacks.id
}
