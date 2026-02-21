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
resource "spacelift_policy_attachment" "global_push_root" {
  policy_id = spacelift_policy.global_push_flow.id
  space_id  = "root"
}

# Environment Guard: Ensures branch names match stack environment labels.
resource "spacelift_policy" "branch_env" {
  name        = "branch-env-guard"
  type        = "PLAN"
  body        = file("${path.module}/policies/branch_env.rego")
  description = "Blocks apply if the VCS branch does not match the stack environment label."
  space_id    = "root"
}

# Explicit attachment to the Root Space ensures global inheritance.
resource "spacelift_policy_attachment" "branch_env_root" {
  policy_id = spacelift_policy.branch_env.id
  space_id  = "root"
}

# --- 2) ADMIN CONTROL PLANE ---

# Admin space (The isolated management folder)
resource "spacelift_space" "admin" {
  parent_space_id = var.admin_space_id
  name            = "Admin"
  description     = "Admin control plane space"
  inherit_entities = true
}

# Admin-stacks stack (The Orchestrator)
resource "spacelift_stack" "admin_stacks" {
  name        = "admin-stacks"
  description = "Creates/applies all other admin control plane stacks"
  space_id    = spacelift_space.admin.id

  # VCS wiring
  repository   = var.admin_stacks_repo
  branch       = var.admin_stacks_branch
  project_root     = "/"

  administrative       = true
  enable_local_preview = true
}

# --- 3) OUTPUTS ---

output "admin_space_id" {
  value = spacelift_space.admin.id
}

output "admin_stacks_stack_id" {
  value = spacelift_stack.admin_stacks.id
}
