locals {
  env_data = yamldecode(file("${path.module}/manifests/environments.yaml"))
  envs     = { for e in local.env_data.environments : e.name => e }
}

# --- 1) CONSTITUTIONAL POLICIES ---
# Defined at root, but enforced at the environment level.

resource "spacelift_policy" "global_push_flow" {
  name        = "global-git-flow"
  type        = "GIT_PUSH"
  body        = file("${path.module}/policies/push/global_flow.rego")
  description = "Enforces main-only deployments and auto-discards redundant queued runs."
  space_id    = "root"
}

resource "spacelift_policy" "branch_env" {
  name        = "branch-env-guard"
  type        = "PLAN"
  body        = file("${path.module}/policies/branch_env.rego")
  description = "Blocks apply if the VCS branch does not match the stack environment label."
  space_id    = "root"
}

# --- 2) MULTI-ENVIRONMENT HIERARCHY ---

# Create the top-level Environment Containers (e.g. Prod)
resource "spacelift_space" "env_root" {
  for_each        = local.envs
  name            = each.key
  description     = each.value.description
  parent_space_id = "root"
  inherit_entities = true
}

# HIGH ASSURANCE ATTACHMENT:
# Attach the law to the Environment Root (e.g. Prod) instead of the account root.
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

# Create the Admin Space inside each Environment
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
  description = "Orchestrator for the ${each.key} environment"
  space_id    = each.value.id

  repository   = var.admin_stacks_repo
  branch       = var.admin_stacks_branch
  project_root = "/"

  autodeploy           = var.enable_auto_deploy
  administrative       = true
  enable_local_preview = true
}

# --- 4) RELATIVE AWARENESS INJECTION ---

resource "spacelift_environment_variable" "orch_env_name" {
  for_each   = spacelift_stack.admin_stacks
  stack_id   = each.value.id
  name       = "TF_VAR_environment_name"
  value      = each.key 
  write_only = false
}

resource "spacelift_environment_variable" "orch_api_id" {
  for_each   = spacelift_stack.admin_stacks
  stack_id   = each.value.id
  name       = "TF_VAR_spacelift_api_key_id"
  value      = var.spacelift_api_key_id
  write_only = true
}

resource "spacelift_environment_variable" "orch_api_secret" {
  for_each   = spacelift_stack.admin_stacks
  stack_id   = each.value.id
  name       = "TF_VAR_spacelift_api_key_secret"
  value      = var.spacelift_api_key_secret
  write_only = true
}

resource "spacelift_environment_variable" "orch_vcs_id" {
  for_each   = spacelift_stack.admin_stacks
  stack_id   = each.value.id
  name       = "TF_VAR_vcs_integration_id"
  value      = var.vcs_integration_id
  write_only = false
}
