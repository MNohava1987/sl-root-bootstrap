locals {
  topology_manifest_path = "${path.module}/manifests/topology/management-plane.yaml"
  env_data               = yamldecode(file(local.topology_manifest_path))

  bootstrap_manifest_path = "${path.module}/manifests/bootstrap/bootstrap-config.yaml"
  naming_manifest_path    = "${path.module}/manifests/governance/naming-catalog.yaml"
  rbac_manifest_path      = "${path.module}/manifests/rbac/role-catalog.yaml"

  bootstrap_manifest = try(yamldecode(file(local.bootstrap_manifest_path)), null)
  naming_manifest    = try(yamldecode(file(local.naming_manifest_path)), null)
  rbac_manifest      = try(yamldecode(file(local.rbac_manifest_path)), null)

  cfg_admin_stacks_repo          = try(local.bootstrap_manifest.bootstrap.admin_stacks_repo, var.admin_stacks_repo)
  cfg_admin_stacks_branch        = try(local.bootstrap_manifest.bootstrap.admin_stacks_branch, var.admin_stacks_branch)
  cfg_enable_auto_deploy         = try(local.bootstrap_manifest.bootstrap.enable_auto_deploy, var.enable_auto_deploy)
  cfg_enable_deletion_protection = try(local.bootstrap_manifest.bootstrap.enable_deletion_protection, var.enable_deletion_protection)

  cfg_naming_org                          = try(local.naming_manifest.tokens.org, var.naming_org)
  cfg_naming_domain                       = try(local.naming_manifest.tokens.domain, var.naming_domain)
  cfg_naming_function_admin_stacks        = try(local.naming_manifest.functions.admin_stacks, var.naming_function_admin_stacks)
  cfg_naming_function_env_root_space      = try(local.naming_manifest.functions.env_root_space, var.naming_function_env_root_space)
  cfg_naming_function_policy_git_flow     = try(local.naming_manifest.functions.policy_git_flow, var.naming_function_policy_git_flow)
  cfg_naming_function_policy_branch_guard = try(local.naming_manifest.functions.policy_branch_guard, var.naming_function_policy_branch_guard)
  cfg_naming_function_policy_approval_law = try(local.naming_manifest.functions.policy_approval_law, var.naming_function_policy_approval_law)
  cfg_naming_function_role_prefix         = try(local.naming_manifest.functions.role_prefix, var.naming_function_role_prefix)
  cfg_naming_token_regex                  = try(local.naming_manifest.rules.token_regex, var.naming_token_regex)
  cfg_naming_max_length                   = try(local.naming_manifest.rules.max_length, var.naming_max_length)

  cfg_naming_enforce_allowed_envs          = try(local.naming_manifest.enforcement.enforce_allowed_envs, var.naming_enforce_allowed_envs)
  cfg_naming_enforce_allowed_domains       = try(local.naming_manifest.enforcement.enforce_allowed_domains, var.naming_enforce_allowed_domains)
  cfg_naming_enforce_allowed_functions     = try(local.naming_manifest.enforcement.enforce_allowed_functions, var.naming_enforce_allowed_functions)
  cfg_naming_enforce_allowed_role_profiles = try(local.naming_manifest.enforcement.enforce_allowed_role_profiles, var.naming_enforce_allowed_role_profiles)

  cfg_allowed_env_tokens          = try(local.naming_manifest.allow_lists.envs, var.allowed_env_tokens)
  cfg_allowed_domain_tokens       = try(local.naming_manifest.allow_lists.domains, var.allowed_domain_tokens)
  cfg_allowed_function_tokens     = try(local.naming_manifest.allow_lists.functions, var.allowed_function_tokens)
  cfg_allowed_role_profile_tokens = try(local.naming_manifest.allow_lists.role_profiles, var.allowed_role_profile_tokens)

  cfg_enable_custom_role_profiles          = try(local.rbac_manifest.settings.enable_custom_role_profiles, var.enable_custom_role_profiles)
  cfg_allow_space_admin_in_custom_profiles = try(local.rbac_manifest.settings.allow_space_admin_in_custom_profiles, var.allow_space_admin_in_custom_profiles)
  cfg_role_profile_actions                 = try(local.rbac_manifest.role_profile_actions, var.role_profile_actions)
  cfg_role_profile_role_slugs              = try(local.rbac_manifest.role_profile_role_slugs, var.role_profile_role_slugs)
}
