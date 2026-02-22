variable "enable_deletion_protection" {
  type        = bool
  default     = false
  description = "DANGER: If false, foundational stacks can be deleted. Keep true for normal operations."
}

variable "repave_mode" {
  type        = bool
  default     = true
  description = "Explicit repave mode switch. Set true only during controlled teardown/rebuild operations."
}

variable "admin_space_id" {
  type        = string
  default     = "root"
  description = "Parent space for environment root spaces."
}

variable "admin_stacks_repo" {
  type    = string
  default = "sl-admin-stacks"
}

variable "admin_stacks_branch" {
  type    = string
  default = "main"
}

variable "enable_auto_deploy" {
  type        = bool
  default     = false
  description = "Enable auto-deploy for management-plane orchestrator stacks."
}

variable "manifest_supported_versions" {
  type        = list(number)
  default     = [1]
  description = "Allowed schema versions for manifests/topology/management-plane.yaml."
}

variable "allowed_assurance_tiers" {
  type        = list(string)
  default     = ["tier-0", "tier-1", "tier-2", "tier-3", "tier-10"]
  description = "Allowed assurance_tier values for environments in the management manifest."
}

variable "required_bootstrap_space_names" {
  type        = list(string)
  default     = ["admin"]
  description = "Bootstrap spaces that must always exist in manifests/topology/management-plane.yaml."
}

variable "enforce_lowercase_environment_names" {
  type        = bool
  default     = false
  description = "When true, all environment names in the manifest must be lowercase."
}

variable "naming_org" {
  type        = string
  default     = "sl"
  description = "Organization token used by the <org>-<env>-<domain>-<function> naming convention."
}

variable "naming_domain" {
  type        = string
  default     = "mgmt"
  description = "Domain token used by the <org>-<env>-<domain>-<function> naming convention."
}

variable "naming_function_admin_stacks" {
  type        = string
  default     = "admin-stacks-orchestrator"
  description = "Function token for Tier-1 admin orchestrator stacks."
}

variable "naming_function_env_root_space" {
  type        = string
  default     = "env-root-space"
  description = "Function token for top-level environment root spaces."
}

variable "naming_function_policy_git_flow" {
  type        = string
  default     = "git-flow"
  description = "Function token for git-flow policies."
}

variable "naming_function_policy_branch_guard" {
  type        = string
  default     = "branch-guard"
  description = "Function token for branch guard policies."
}

variable "naming_function_policy_approval_law" {
  type        = string
  default     = "approval-law"
  description = "Function token for approval policies."
}

variable "naming_function_role_prefix" {
  type        = string
  default     = "role"
  description = "Function token prefix used for custom role names (<org>-<domain>-role-<profile>)."
}

variable "naming_token_regex" {
  type        = string
  default     = "^[a-z0-9]+(-[a-z0-9]+)*$"
  description = "Regex contract for naming tokens."
}

variable "naming_max_length" {
  type        = number
  default     = 63
  description = "Maximum length for generated canonical names."
}

variable "naming_enforce_allowed_envs" {
  type        = bool
  default     = false
  description = "When true, environment tokens must be in allowed_env_tokens."
}

variable "allowed_env_tokens" {
  type        = list(string)
  default     = ["live", "prod", "stage", "test", "dev", "sandbox", "matt-test1"]
  description = "Allow-list for environment tokens."
}

variable "naming_enforce_allowed_domains" {
  type        = bool
  default     = true
  description = "When true, naming_domain must be in allowed_domain_tokens."
}

variable "allowed_domain_tokens" {
  type        = list(string)
  default     = ["mgmt", "network", "security", "identity", "data", "app", "observability", "shared"]
  description = "Allow-list for domain tokens."
}

variable "naming_enforce_allowed_functions" {
  type        = bool
  default     = false
  description = "When true, function tokens must be in allowed_function_tokens."
}

variable "allowed_function_tokens" {
  type = list(string)
  default = [
    "admin-stacks-orchestrator",
    "env-root-space",
    "git-flow",
    "branch-guard",
    "approval-law",
    "role"
  ]
  description = "Allow-list for function tokens."
}

variable "naming_enforce_allowed_role_profiles" {
  type        = bool
  default     = false
  description = "When true, custom role profile tokens must be in allowed_role_profile_tokens."
}

variable "allowed_role_profile_tokens" {
  type        = list(string)
  default     = ["stack-manager", "space-manager", "policy-manager", "readonly-auditor", "space-admin"]
  description = "Allow-list for role profile tokens used as <profile> in custom role naming."
}

variable "role_profile_role_slugs" {
  type = map(string)
  default = {
    "stack-manager"    = "space-admin"
    "space-manager"    = "space-admin"
    "policy-manager"   = "space-admin"
    "readonly-auditor" = "space-admin"
    "space-admin"      = "space-admin"
  }
  description = "Baseline map of role profile names to Spacelift role slugs. Defaults map all profiles to space-admin for safe bootstrap compatibility."
}

variable "enable_custom_role_profiles" {
  type        = bool
  default     = true
  description = "When true, create custom Spacelift roles for non-admin role profiles."
}

variable "role_profile_actions" {
  type = map(list(string))
  default = {
    "stack-manager" = [
      "SPACE_READ",
      "SPACE_WRITE",
      "RUN_TRIGGER",
      "TASK_CREATE",
      "STACK_CREATE",
      "STACK_UPDATE",
      "STACK_DELETE",
      "STACK_LOCK",
      "STACK_UNLOCK",
      "STACK_ADD_CONFIG",
      "STACK_DELETE_CONFIG",
      "STACK_SET_CURRENT_COMMIT",
      "STACK_SYNC_COMMIT",
      "STACK_UPLOAD_LOCAL_WORKSPACE",
      "STACK_STATE_READ"
    ]
    "space-manager" = [
      "SPACE_READ",
      "SPACE_WRITE"
    ]
    "policy-manager" = [
      "SPACE_READ",
      "SPACE_WRITE"
    ]
    "readonly-auditor" = ["SPACE_READ"]
  }
  description = "Actions assigned to custom role profiles. These defaults are least-privilege first-pass mappings; validate against your account action catalog."
}

variable "allow_space_admin_in_custom_profiles" {
  type        = bool
  default     = false
  description = "When false, custom role profiles cannot include SPACE_ADMIN in role_profile_actions."
}
