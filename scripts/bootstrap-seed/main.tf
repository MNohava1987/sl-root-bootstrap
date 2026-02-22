locals {
  bootstrap_stack_name = "${local.cfg_naming_org}-${local.cfg_naming_env}-${local.cfg_naming_domain}-${local.cfg_naming_function_bootstrap}"
  root_git_flow_name   = "${local.cfg_naming_org}-${local.cfg_naming_env}-${local.cfg_naming_domain}-${local.cfg_naming_function_policy_git_flow}"
  root_approval_name   = "${local.cfg_naming_org}-${local.cfg_naming_env}-${local.cfg_naming_domain}-${local.cfg_naming_function_policy_approval_law}"
}

# Tier-0 root policies. These govern the bootstrap stack path.
# Policies in root apply to root and child spaces.
resource "spacelift_policy" "root_push_flow" {
  name        = local.root_git_flow_name
  type        = "GIT_PUSH"
  body        = file("${path.module}/policies/push/global_flow.rego")
  description = "Tier 0 Governance: Enforces main-only deployments for the bootstrap stack."
  space_id    = "root"
}

resource "spacelift_policy" "root_approval" {
  name        = local.root_approval_name
  type        = "APPROVAL"
  body        = file("${path.module}/policies/approval/global_approval.rego")
  description = "Tier 0 Governance: Requires approval for bootstrap changes."
  space_id    = "root"
}

# Seed the Tier-0 bootstrap stack in root.
resource "spacelift_stack" "bootstrap" {
  name        = local.bootstrap_stack_name
  repository  = local.cfg_bootstrap_stack_repository
  branch      = local.cfg_bootstrap_stack_branch
  space_id    = "root"
  description = "Foundational Bootstrap Stack (Locally Seeded - High Assurance)"

  github_enterprise {
    id        = data.spacelift_github_enterprise_integration.target.id
    namespace = var.vcs_namespace
  }

  # Functional labels drive policy behavior.
  labels = [
    "stack-type:management", # Main-branch deployment policy target.
    "assurance:tier-0"       # Tier-0 approval policy target.
  ]

  # DANGER: Turning this off allows deletion of the bootstrap identity.
  # Keep enabled unless you are intentionally repaving Tier-0.
  protect_from_deletion = var.enable_deletion_protection
  enable_local_preview  = true
  autodeploy            = false
}

# Grant bootstrap stack admin permissions in root.
resource "spacelift_role_attachment" "bootstrap_admin" {
  space_id = "root"
  stack_id = spacelift_stack.bootstrap.id
  role_id  = data.spacelift_role.space_admin.id
}
