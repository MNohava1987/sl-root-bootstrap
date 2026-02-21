locals {
  env_data = yamldecode(file("${path.module}/manifests/management-plane.yaml"))
  
  # Dual-safety: handles missing keys (via try) AND explicit nulls (via conditional)
  envs_list = try(local.env_data.environments, [])
  envs      = { for e in (local.envs_list == null ? [] : local.envs_list) : e.name => e }
  
  # Templates for sub-structure inside every environment (from YAML)
  boot_list           = try(local.env_data.bootstrap_spaces, [])
  bootstrap_templates = { for s in (local.boot_list == null ? [] : local.boot_list) : s.name => s }

  # Flattened matrix: Environment x Bootstrap Space
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
# Names are unique per environment to avoid account-level slug conflicts.
resource "spacelift_policy" "env_push_flow" {
  for_each    = local.envs
  name        = "${lower(each.key)}-git-flow"
  type        = "GIT_PUSH"
  body        = file("${path.module}/policies/push/global_flow.rego")
  description = "Enforces main-only deployments for critical stacks in ${each.key}."
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
  description = "Requires approval for orchestrators and critical stacks in ${each.key}."
  space_id    = spacelift_space.env_root[each.key].id
}

# --- 2) THE HIERARCHY CREATION ---

# Top-level Environment Container
resource "spacelift_space" "env_root" {
  for_each         = local.envs
  name             = each.key
  description      = each.value.description
  parent_space_id  = "root"
  
  # HIGH ASSURANCE BOUNDARY: Turn off inheritance from root to prevent policy leakage.
  inherit_entities = false 

  labels = [
    "environment:${lower(each.key)}",
    "assurance:${each.value.assurance_tier}",
    "governance:env-guard"
  ]
}

# Sub-spaces inside each environment (e.g. Live/admin)
resource "spacelift_space" "env_sub_space" {
  for_each         = local.env_sub_spaces
  name             = each.value.sub_name
  description      = each.value.description
  parent_space_id  = spacelift_space.env_root[each.value.env_name].id
  
  # INTERNAL INHERITANCE: Sub-spaces inherit from their parent environment root.
  inherit_entities = true 
}

# --- 3) ORCHESTRATION ---

resource "spacelift_stack" "admin_stacks" {
  for_each    = local.envs
  name        = "admin-stacks-orchestrator"
  description = "Orchestrator for the ${each.key} management plane"
  space_id    = spacelift_space.env_sub_space["${each.key}.admin"].id

  repository   = var.admin_stacks_repo
  branch       = var.admin_stacks_branch
  project_root = "/"

  autodeploy           = var.enable_auto_deploy
  enable_local_preview = true
  protect_from_deletion = var.enable_deletion_protection

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

# --- 4) HIGH ASSURANCE VALIDATION (CHECK BLOCKS) ---

# Verifies the Hard Boundary is maintained for all environments
check "environment_isolation" {
  assert {
    condition     = alltrue([for s in spacelift_space.env_root : s.inherit_entities == false])
    error_message = "Environment root spaces MUST have inherit_entities set to false for hard isolation."
  }
}

# Verifies that all Orchestrators are correctly categorized
check "orchestrator_governance" {
  assert {
    condition     = alltrue([for s in spacelift_stack.admin_stacks : contains(s.labels, "assurance:tier-1")])
    error_message = "All orchestrator stacks MUST carry the 'assurance:tier-1' functional label."
  }
}
