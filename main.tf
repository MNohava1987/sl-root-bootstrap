locals {
  # Read environments safely. Handles missing keys and explicit null values.
  envs_list = try(
    [for e in local.env_data.environments : e],
    []
  )
  enabled_envs = [
    for e in local.envs_list : e
    if local.cfg_enable_component && try(e.enabled, true)
  ]
  envs = local.cfg_enable_component ? {
    for e in local.enabled_envs : e.name => e
  } : {}

  # Read bootstrap sub-space templates from manifest.
  boot_list = try(
    [for s in local.env_data.bootstrap_spaces : s],
    []
  )
  enabled_bootstrap_spaces = [
    for s in local.boot_list : s
    if local.cfg_enable_component && try(s.enabled, true)
  ]
  bootstrap_templates = {
    for s in local.enabled_bootstrap_spaces : s.name => s
  }

  # Build Environment x Bootstrap Space matrix.
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

# --- Dynamic Discovery ---

# Resolve Space Admin role ID for role attachments.
data "spacelift_role" "space_admin" {
  slug = "space-admin"
}

# --- Environment Policies ---

# One policy set per environment. Names must stay globally unique.
resource "spacelift_policy" "env_push_flow" {
  for_each    = local.envs
  name        = "${local.cfg_naming_org}-${lower(each.key)}-${local.cfg_naming_domain}-${local.cfg_naming_function_policy_git_flow}"
  type        = "GIT_PUSH"
  body        = file("${path.module}/policies/push/global_flow.rego")
  description = "Enforces main-only deployments for critical stacks in ${each.key}."
  space_id    = spacelift_space.env_root[each.key].id
}

resource "spacelift_policy" "env_branch_guard" {
  for_each    = local.envs
  name        = "${local.cfg_naming_org}-${lower(each.key)}-${local.cfg_naming_domain}-${local.cfg_naming_function_policy_branch_guard}"
  type        = "PLAN"
  body        = file("${path.module}/policies/branch_env.rego")
  description = "Blocks apply if branch name mismatch in ${each.key}."
  space_id    = spacelift_space.env_root[each.key].id
}

resource "spacelift_policy" "env_approval" {
  for_each    = local.envs
  name        = "${local.cfg_naming_org}-${lower(each.key)}-${local.cfg_naming_domain}-${local.cfg_naming_function_policy_approval_law}"
  type        = "APPROVAL"
  body        = file("${path.module}/policies/approval/global_approval.rego")
  description = "Requires approval for orchestrators and critical stacks in ${each.key}."
  space_id    = spacelift_space.env_root[each.key].id
}

# --- Space Hierarchy ---

# Top-level environment root space.
resource "spacelift_space" "env_root" {
  for_each        = local.envs
  name            = "${local.cfg_naming_org}-${lower(each.key)}-${local.cfg_naming_domain}-${local.cfg_naming_function_env_root_space}"
  description     = each.value.description
  parent_space_id = "root"

  # HARD ISOLATION. Do not inherit root entities into environment roots.
  inherit_entities = false

  labels = [
    "environment:${lower(each.key)}",
    "assurance:${each.value.assurance_tier}",
    "governance:env-guard"
  ]
}

# Environment sub-spaces (example: live/admin).
resource "spacelift_space" "env_sub_space" {
  for_each        = local.env_sub_spaces
  name            = each.value.sub_name
  description     = each.value.description
  parent_space_id = spacelift_space.env_root[each.value.env_name].id

  # Sub-spaces inherit from their environment root by design.
  inherit_entities = true
}

# --- Orchestration ---

resource "spacelift_stack" "admin_stacks" {
  for_each    = local.envs
  name        = "${local.cfg_naming_org}-${lower(each.key)}-${local.cfg_naming_domain}-${local.cfg_naming_function_admin_stacks}"
  description = "Orchestrator for the ${each.key} management plane"
  space_id    = spacelift_space.env_sub_space["${each.key}.admin"].id

  repository   = local.cfg_admin_stacks_repo
  branch       = local.cfg_admin_stacks_branch
  project_root = "/"

  autodeploy           = local.cfg_enable_auto_deploy
  enable_local_preview = true
  # DANGER: Turning this off allows stack deletion.
  # Keep enabled unless you are intentionally tearing down this layer.
  protect_from_deletion = local.cfg_enable_deletion_protection

  labels = [
    "stack-type:management",
    "assurance:tier-1",
    "environment:${lower(each.key)}",
    "assurance:${local.envs[each.key].assurance_tier}",
    "governance:env-guard"
  ]
}

# Preferred replacement for deprecated administrative stack mode.
resource "spacelift_role_attachment" "admin_stacks" {
  for_each = local.envs

  stack_id = spacelift_stack.admin_stacks[each.key].id
  role_id  = data.spacelift_role.space_admin.id
  space_id = spacelift_space.env_root[each.key].id
}

# Ensure Tier-1 orchestrators always receive exact environment context values
# from bootstrap, avoiding path/casing drift in downstream lookups.
resource "spacelift_environment_variable" "admin_stacks_context_vars" {
  for_each = merge([
    for env_name, stack in spacelift_stack.admin_stacks : {
      "${env_name}.TF_VAR_environment_name" = {
        stack_id = stack.id
        name     = "TF_VAR_environment_name"
        value    = env_name
      }
      "${env_name}.TF_VAR_assurance_tier" = {
        stack_id = stack.id
        name     = "TF_VAR_assurance_tier"
        value    = local.envs[env_name].assurance_tier
      }
      "${env_name}.TF_VAR_naming_org" = {
        stack_id = stack.id
        name     = "TF_VAR_naming_org"
        value    = local.cfg_naming_org
      }
      "${env_name}.TF_VAR_naming_domain" = {
        stack_id = stack.id
        name     = "TF_VAR_naming_domain"
        value    = local.cfg_naming_domain
      }
      "${env_name}.TF_VAR_naming_function_env_root_space" = {
        stack_id = stack.id
        name     = "TF_VAR_naming_function_env_root_space"
        value    = local.cfg_naming_function_env_root_space
      }
      "${env_name}.TF_VAR_admin_sub_space_name" = {
        stack_id = stack.id
        name     = "TF_VAR_admin_sub_space_name"
        value    = "admin"
      }
      "${env_name}.TF_VAR_repave_mode" = {
        stack_id = stack.id
        name     = "TF_VAR_repave_mode"
        value    = tostring(local.cfg_repave_mode)
      }
      "${env_name}.TF_VAR_enable_deletion_protection" = {
        stack_id = stack.id
        name     = "TF_VAR_enable_deletion_protection"
        value    = tostring(local.cfg_enable_deletion_protection)
      }
    }
  ]...)

  stack_id   = each.value.stack_id
  name       = each.value.name
  value      = each.value.value
  write_only = false
}

# Execute in-stack destroys before deleting Tier-1 orchestrators during repave.
resource "spacelift_stack_destructor" "admin_stacks" {
  for_each = spacelift_stack.admin_stacks

  stack_id = each.value.id

  discard_runs = true
  deactivated  = !local.cfg_repave_mode

  depends_on = [
    spacelift_role_attachment.admin_stacks,
    spacelift_environment_variable.admin_stacks_context_vars
  ]
}
