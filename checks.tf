locals {
  manifest_version      = try(local.env_data.manifest_version, null)
  env_names             = [for e in(local.envs_list == null ? [] : local.envs_list) : e.name]
  env_names_lower       = [for name in local.env_names : lower(name)]
  assurance_tiers       = [for e in values(local.envs) : e.assurance_tier]
  bootstrap_space_names = [for s in(local.boot_list == null ? [] : local.boot_list) : s.name]
}

# --- CONTRACT VALIDATION ---

check "manifest_version_supported" {
  assert {
    condition     = local.manifest_version != null && contains(var.manifest_supported_versions, local.manifest_version)
    error_message = "Manifest must declare a supported manifest_version in manifests/management-plane.yaml."
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

# --- HIGH ASSURANCE VALIDATION ---

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
