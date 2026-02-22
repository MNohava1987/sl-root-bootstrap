locals {
  manifest_version      = try(local.env_data.manifest_version, null)
  env_names             = [for e in(local.envs_list == null ? [] : local.envs_list) : e.name]
  env_names_lower       = [for name in local.env_names : lower(name)]
  assurance_tiers       = [for e in values(local.envs) : e.assurance_tier]
  bootstrap_space_names = [for s in(local.boot_list == null ? [] : local.boot_list) : s.name]

  naming_function_tokens = [
    local.cfg_naming_function_admin_stacks,
    local.cfg_naming_function_env_root_space,
    local.cfg_naming_function_policy_git_flow,
    local.cfg_naming_function_policy_branch_guard,
    local.cfg_naming_function_policy_approval_law,
    local.cfg_naming_function_role_prefix
  ]

  role_profile_tokens = keys(local.cfg_role_profile_actions)

  canonical_stack_names = [
    for env in local.env_names_lower :
    "${local.cfg_naming_org}-${env}-${local.cfg_naming_domain}-${local.cfg_naming_function_admin_stacks}"
  ]

  canonical_env_root_space_names = [
    for env in local.env_names_lower :
    "${local.cfg_naming_org}-${env}-${local.cfg_naming_domain}-${local.cfg_naming_function_env_root_space}"
  ]

  canonical_policy_names = flatten([
    for env in local.env_names_lower : [
      "${local.cfg_naming_org}-${env}-${local.cfg_naming_domain}-${local.cfg_naming_function_policy_git_flow}",
      "${local.cfg_naming_org}-${env}-${local.cfg_naming_domain}-${local.cfg_naming_function_policy_branch_guard}",
      "${local.cfg_naming_org}-${env}-${local.cfg_naming_domain}-${local.cfg_naming_function_policy_approval_law}"
    ]
  ])

  canonical_role_names = [
    for profile in local.role_profile_tokens :
    "${local.cfg_naming_org}-${local.cfg_naming_domain}-${local.cfg_naming_function_role_prefix}-${profile}"
    if profile != "space-admin"
  ]

  canonical_names = concat(
    local.canonical_stack_names,
    local.canonical_env_root_space_names,
    local.canonical_policy_names,
    local.canonical_role_names
  )
}

# --- Manifest Contracts ---

check "manifest_version_supported" {
  assert {
    condition     = local.manifest_version != null && contains(var.manifest_supported_versions, local.manifest_version)
    error_message = "Topology manifest must declare a supported manifest_version."
  }
}

check "bootstrap_manifest_version_supported" {
  assert {
    condition     = !fileexists(local.bootstrap_manifest_path) || contains(var.manifest_supported_versions, try(local.bootstrap_manifest.manifest_version, -1))
    error_message = "Bootstrap manifest must declare a supported manifest_version."
  }
}

check "naming_manifest_version_supported" {
  assert {
    condition     = !fileexists(local.naming_manifest_path) || contains(var.manifest_supported_versions, try(local.naming_manifest.manifest_version, -1))
    error_message = "Naming catalog manifest must declare a supported manifest_version."
  }
}

check "rbac_manifest_version_supported" {
  assert {
    condition     = !fileexists(local.rbac_manifest_path) || contains(var.manifest_supported_versions, try(local.rbac_manifest.manifest_version, -1))
    error_message = "RBAC catalog manifest must declare a supported manifest_version."
  }
}

check "environment_names_unique_case_insensitive" {
  assert {
    condition     = length(distinct(local.env_names_lower)) == length(local.env_names_lower)
    error_message = "Environment names must be unique (case-insensitive)."
  }
}

check "environment_names_lowercase" {
  assert {
    condition     = !var.enforce_lowercase_environment_names || alltrue([for name in local.env_names : name == lower(name)])
    error_message = "All environment names must be lowercase when enforce_lowercase_environment_names is enabled."
  }
}

check "assurance_tiers_allowed" {
  assert {
    condition     = alltrue([for tier in local.assurance_tiers : contains(var.allowed_assurance_tiers, tier)])
    error_message = "One or more environments use an assurance_tier that is not in allowed_assurance_tiers."
  }
}

check "bootstrap_spaces_unique" {
  assert {
    condition     = length(distinct(local.bootstrap_space_names)) == length(local.bootstrap_space_names)
    error_message = "bootstrap_spaces names must be unique."
  }
}

check "required_bootstrap_spaces_present" {
  assert {
    condition     = alltrue([for name in var.required_bootstrap_space_names : contains(local.bootstrap_space_names, name)])
    error_message = "Manifest is missing one or more required bootstrap spaces."
  }
}

check "required_subspaces_exist_for_each_environment" {
  assert {
    condition = alltrue(flatten([
      for env_name, _ in local.envs : [
        for space_name in var.required_bootstrap_space_names :
        contains(keys(local.env_sub_spaces), "${env_name}.${space_name}")
      ]
    ]))
    error_message = "Each environment must produce all required bootstrap sub-spaces."
  }
}

# --- Naming Contracts ---

check "naming_org_token_valid" {
  assert {
    condition     = can(regex(local.cfg_naming_token_regex, local.cfg_naming_org))
    error_message = "naming_org must match naming_token_regex."
  }
}

check "naming_domain_token_valid" {
  assert {
    condition     = can(regex(local.cfg_naming_token_regex, local.cfg_naming_domain))
    error_message = "naming_domain must match naming_token_regex."
  }
}

check "naming_function_tokens_valid" {
  assert {
    condition     = alltrue([for token in local.naming_function_tokens : can(regex(local.cfg_naming_token_regex, token))])
    error_message = "All naming function tokens must match naming_token_regex."
  }
}

check "role_profile_tokens_valid" {
  assert {
    condition     = alltrue([for token in local.role_profile_tokens : can(regex(local.cfg_naming_token_regex, token))])
    error_message = "All role profile tokens must match naming_token_regex."
  }
}

check "allowed_environment_tokens" {
  assert {
    condition     = !local.cfg_naming_enforce_allowed_envs || alltrue([for env in local.env_names_lower : contains(local.cfg_allowed_env_tokens, env)])
    error_message = "One or more environment tokens are not present in allowed_env_tokens."
  }
}

check "allowed_domain_token" {
  assert {
    condition     = !local.cfg_naming_enforce_allowed_domains || contains(local.cfg_allowed_domain_tokens, local.cfg_naming_domain)
    error_message = "naming_domain is not present in allowed_domain_tokens."
  }
}

check "allowed_function_tokens" {
  assert {
    condition     = !local.cfg_naming_enforce_allowed_functions || alltrue([for token in local.naming_function_tokens : contains(local.cfg_allowed_function_tokens, token)])
    error_message = "One or more naming function tokens are not present in allowed_function_tokens."
  }
}

check "allowed_role_profile_tokens" {
  assert {
    condition     = !local.cfg_naming_enforce_allowed_role_profiles || alltrue([for token in local.role_profile_tokens : contains(local.cfg_allowed_role_profile_tokens, token)])
    error_message = "One or more role profile tokens are not present in allowed_role_profile_tokens."
  }
}

check "canonical_names_match_pattern" {
  assert {
    condition     = alltrue([for name in local.canonical_names : can(regex(local.cfg_naming_token_regex, name))])
    error_message = "Generated canonical names must match naming_token_regex."
  }
}

check "canonical_name_lengths" {
  assert {
    condition     = alltrue([for name in local.canonical_names : length(name) <= local.cfg_naming_max_length])
    error_message = "Generated canonical names exceed naming_max_length."
  }
}

# --- High-Assurance Controls ---

check "environment_isolation" {
  assert {
    condition     = alltrue([for s in spacelift_space.env_root : s.inherit_entities == false])
    error_message = "Environment root spaces MUST have inherit_entities set to false for hard isolation."
  }
}

check "orchestrator_governance" {
  assert {
    condition = alltrue([
      for s in spacelift_stack.admin_stacks :
      contains(s.labels, "stack-type:management") &&
      contains(s.labels, "assurance:tier-1") &&
      contains(s.labels, "governance:env-guard")
    ])
    error_message = "All orchestrator stacks MUST carry required governance labels."
  }
}

# --- RBAC Guardrails ---

check "custom_role_profiles_require_non_admin_slugs" {
  assert {
    condition = !local.cfg_enable_custom_role_profiles || alltrue([
      for profile, slug in local.role_profile_slugs :
      profile == "space-admin" || slug != "space-admin"
    ])
    error_message = "When enable_custom_role_profiles is true, non-admin role profiles must not map to space-admin."
  }
}

check "custom_role_profiles_require_non_admin_actions" {
  assert {
    condition = !local.cfg_enable_custom_role_profiles || local.cfg_allow_space_admin_in_custom_profiles || alltrue(flatten([
      for profile, actions in local.cfg_role_profile_actions : [
        for action in actions : profile == "space-admin" || action != "SPACE_ADMIN"
      ]
    ]))
    error_message = "Custom role profiles must not include SPACE_ADMIN unless allow_space_admin_in_custom_profiles is true."
  }
}
