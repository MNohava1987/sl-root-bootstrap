locals {
  env_data = yamldecode(file("${path.module}/manifests/environments.yaml"))
  envs     = { for e in local.env_data.environments : e.name => e }
}

# --- 1) CONSTITUTIONAL POLICIES ---

resource "spacelift_policy" "global_push_flow" {
  name        = "global-git-flow"
  type        = "GIT_PUSH"
  body        = file("${path.module}/policies/push/global_flow.rego")
  description = "Enforces main-only deployments for management stacks."
  space_id    = "root"
}

resource "spacelift_policy" "branch_env" {
  name        = "branch-env-guard"
  type        = "PLAN"
  body        = file("${path.module}/policies/branch_env.rego")
  description = "Blocks apply if branch name mismatch."
  space_id    = "root"
}

resource "spacelift_policy" "global_approval" {
  name        = "global-approval-law"
  type        = "APPROVAL"
  body        = file("${path.module}/policies/approval/global_approval.rego")
  description = "Requires approval for Tier 0 and Tier 1 stacks."
  space_id    = "root"
}

# --- 2) MULTI-ENVIRONMENT HIERARCHY ---

# Create the top-level Environment Containers (e.g. Live)
resource "spacelift_space" "env_root" {
  for_each        = local.envs
  name            = each.key
  description     = each.value.description
  parent_space_id = "root"
  inherit_entities = true

  # Functional Labeling at the space level
  labels = ["environment:${lower(each.key)}"]
}

# Attach Law to the Environment Layer
resource "spacelift_policy_attachment" "global_flow" {
  for_each  = spacelift_space.env_root
  policy_id = spacelift_policy.global_push_flow.id
  space_id  = each.value.id
}

resource "spacelift_policy_attachment" "branch_guard" {
  for_each  = spacelift_space.env_root
  policy_id = spacelift_policy.branch_env.id
  space_id  = each.value.id
}

resource "spacelift_policy_attachment" "approval_guard" {
  for_each  = spacelift_space.env_root
  policy_id = spacelift_policy.global_approval.id
  space_id  = each.value.id
}

# Create the Admin Space inside each Environment (Live/Admin)
resource "spacelift_space" "admin" {
  for_each        = spacelift_space.env_root
  name            = "Admin"
  parent_space_id = each.value.id
  inherit_entities = true
}

# --- 3) ENVIRONMENT-AWARE ORCHESTRATORS ---

resource "spacelift_stack" "admin_stacks" {
  for_each    = spacelift_space.admin
  name        = "admin-stacks"
  description = "Orchestrator for the ${each.key} management plane"
  space_id    = each.value.id

  repository   = var.admin_stacks_repo
  branch       = var.admin_stacks_branch
  project_root = "/"

  autodeploy           = var.enable_auto_deploy
  administrative       = true
  enable_local_preview = true

  # Functional Labels for the Orchestrator (Tier 1)
  labels = [
    "stack-type:management",
    "assurance:tier-1",
    "environment:${lower(each.key)}"
  ]
}

# --- 4) RELATIVE AWARENESS INJECTION ---

resource "spacelift_environment_variable" "orch_env_name" {
  for_each   = spacelift_stack.admin_stacks
  stack_id   = each.value.id
  name       = "TF_VAR_environment_name"
  value      = each.key 
  write_only = false
}

# --- 5) OUTPUTS ---

output "management_plane_ids" {
  value = { for k, v in spacelift_space.admin : k => v.id }
}
