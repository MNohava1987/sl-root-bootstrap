# --- 1) ACCOUNT-WIDE POLICIES (THE CONSTITUTION) ---

# Global Push Policy: Enforces main-only deploys and auto-cleans duplicates.
resource "spacelift_policy" "global_push_flow" {
  name        = "global-git-flow"
  type        = "GIT_PUSH"
  body        = file("${path.module}/policies/push/global_flow.rego")
  description = "Enforces main-only deployments and auto-discards redundant queued runs."
  space_id    = "root"
}

# Environment Guard: Ensures branch names match stack environment labels.
resource "spacelift_policy" "branch_env" {
  name        = "branch-env-guard"
  type        = "PLAN"
  body        = file("${path.module}/policies/branch_env.rego")
  description = "Blocks apply if the VCS branch does not match the stack environment label."
  space_id    = "root"
}

# --- 2) ADMIN CONTROL PLANE ---

# Admin space (The isolated management folder)
# We apply the policies here. Because all other spaces (Platform, Modules)
# are children of Admin, they will inherit these policies.
resource "spacelift_space" "admin" {
  parent_space_id = var.admin_space_id
  name            = "Admin"
  description     = "Admin control plane space"
  inherit_entities = true
}

# --- 3) ATTACH POLICIES TO STACKS DIRECTLY (FOR ROOT STACKS) ---

# Since we can't easily attach to the root space via TF without re-defining the 
# root space itself (which we shouldn't do), we attach them to the Admin-Stacks
# and Bootstrap stacks directly. 

resource "spacelift_policy_attachment" "bootstrap_push" {
  policy_id = spacelift_policy.global_push_flow.id
  stack_id  = "sl-root-bootstrap"
}

resource "spacelift_policy_attachment" "orchestrator_push" {
  policy_id = spacelift_policy.global_push_flow.id
  stack_id  = spacelift_stack.admin_stacks.id
}

# --- 4) ADMIN STACKS ORCHESTRATOR ---

resource "spacelift_stack" "admin_stacks" {
  name        = "admin-stacks"
  description = "Creates/applies all other admin control plane stacks"
  space_id    = spacelift_space.admin.id

  repository   = var.admin_stacks_repo
  branch       = var.admin_stacks_branch
  project_root     = "/"
  
  autodeploy = var.enable_auto_deploy
  administrative       = true
  enable_local_preview = true
}

# --- 5) OUTPUTS ---

output "admin_space_id" {
  value = spacelift_space.admin.id
}

output "admin_stacks_stack_id" {
  value = spacelift_stack.admin_stacks.id
}
