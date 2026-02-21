locals {
  env_data = yamldecode(file("${path.module}/manifests/management-plane.yaml"))
  envs     = { for e in local.env_data.environments : e.name => e }
  
  # Templates for sub-structure inside every environment (from YAML)
  bootstrap_templates = { for s in try(local.env_data.bootstrap_spaces, []) : s.name => s }

  # Flattened matrix: Environment x Bootstrap Space
  # Format: "Live.admin", "Live.Security", etc.
  env_sub_spaces = merge([
    for env_name, env in local.envs : {
      for sub_name, sub in local.bootstrap_templates : "${env_name}.${sub_name}" => {
        env_name    = env_name
        sub_name    = sub_name
        description = sub.description
      }
    }
  ]...)
}

# --- 0) DYNAMIC DISCOVERY ---

# Resolve the Space Admin role ID for permission granting
data "spacelift_role" "space_admin" {
  slug = "space-admin"
}

# --- 1) CONSTITUTIONAL POLICIES (ENVIRONMENT-SPECIFIC) ---

# Isolated Law per Container
# Names are now unique per environment to avoid account-level slug conflicts.
resource "spacelift_policy" "env_push_flow" {
  for_each    = local.envs
  name        = "${lower(each.key)}-git-flow"
  type        = "GIT_PUSH"
  body        = file("${path.module}/policies/push/global_flow.rego")
  description = "Enforces main-only deployments for management stacks in ${each.key}."
  space_id    = spacelift_space.env_root[each.key].id
}

resource "spacelift_policy" "env_branch_guard" {
  for_each    = local.envs
  name        = "${lower(each.key)}-branch-guard"
  type        = "PLAN"
  body        = file("${path.module}/policies/branch_env.rego")
  description = "Blocks apply if branch name mismatch in ${each.key}."
  space_id    = spacelift_space.env_root[each.key].id
}

resource "spacelift_policy" "env_approval" {
  for_each    = local.envs
  name        = "${lower(each.key)}-approval-law"
  type        = "APPROVAL"
  body        = file("${path.module}/policies/approval/global_approval.rego")
  description = "Requires approval for management stacks in ${each.key}."
  space_id    = spacelift_space.env_root[each.key].id
}

# --- 2) THE HIERARCHY CREATION ---

resource "spacelift_space" "env_root" {
  for_each        = local.envs
  name            = each.key
  description     = each.value.description
  parent_space_id = "root"
  inherit_entities = true
  
  labels = [
    "environment:${lower(each.key)}",
    "assurance:${each.value.assurance_tier}",
    "governance:env-guard"
  ]
}

# Sub-spaces within each environment
# Using a unique name per environment to satisfy account-level requirements.
resource "spacelift_space" "env_sub_space" {
  for_each        = local.env_sub_spaces
  name            = "${lower(each.value.env_name)}-${each.value.sub_name}"
  description     = each.value.description
  parent_space_id = spacelift_space.env_root[each.value.env_name].id
  inherit_entities = true
}

# --- 3) ORCHESTRATION ---

resource "spacelift_stack" "admin_stacks" {
  for_each    = local.envs
  name        = "${lower(each.key)}-admin-stacks"
  description = "Orchestrator for the ${each.key} management plane"
  
  # Resolve the ID of the 'admin' sub-space for this environment
  space_id    = spacelift_space.env_sub_space["${each.key}.admin"].id

  repository   = var.admin_stacks_repo
  branch       = var.admin_stacks_branch
  project_root = "/"

  autodeploy           = var.enable_auto_deploy
  enable_local_preview = true

  labels = [
    "stack-type:management",
    "assurance:tier-1",
    "environment:${lower(each.key)}",
    "assurance:${local.envs[each.key].assurance_tier}",
    "governance:env-guard"
  ]
}

# Modern Replacement for administrative = true
resource "spacelift_role_attachment" "admin_stacks" {
  for_each = local.envs
  
  stack_id = spacelift_stack.admin_stacks[each.key].id
  role_id  = data.spacelift_role.space_admin.id
  space_id = spacelift_space.env_root[each.key].id
}

resource "spacelift_environment_variable" "orch_env_name" {
  for_each   = spacelift_stack.admin_stacks
  stack_id   = each.value.id
  name       = "TF_VAR_environment_name"
  value      = each.key 
  write_only = false
}
