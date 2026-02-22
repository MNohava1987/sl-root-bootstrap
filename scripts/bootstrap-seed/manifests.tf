locals {
  # Seed config lives in a local bootstrap manifest.
  bootstrap_manifest_path = "${path.module}/manifests/bootstrap/bootstrap-config.yaml"
  bootstrap_manifest      = try(yamldecode(file(local.bootstrap_manifest_path)), null)

  cfg_bootstrap_stack_repository = try(local.bootstrap_manifest.bootstrap.bootstrap_stack_repository, var.bootstrap_stack_repository)
  cfg_bootstrap_stack_branch     = try(local.bootstrap_manifest.bootstrap.bootstrap_stack_branch, var.bootstrap_stack_branch)
  cfg_enable_deletion_protection = try(local.bootstrap_manifest.bootstrap.enable_deletion_protection, var.enable_deletion_protection)

  cfg_naming_org                          = try(local.bootstrap_manifest.naming.org, var.naming_org)
  cfg_naming_env                          = try(local.bootstrap_manifest.naming.env, var.naming_env)
  cfg_naming_domain                       = try(local.bootstrap_manifest.naming.domain, var.naming_domain)
  cfg_naming_function_bootstrap           = try(local.bootstrap_manifest.naming.function_bootstrap, var.naming_function_bootstrap)
  cfg_naming_function_policy_git_flow     = try(local.bootstrap_manifest.naming.function_policy_git_flow, var.naming_function_policy_git_flow)
  cfg_naming_function_policy_approval_law = try(local.bootstrap_manifest.naming.function_policy_approval_law, var.naming_function_policy_approval_law)
}

check "bootstrap_manifest_version_supported" {
  assert {
    condition     = !fileexists(local.bootstrap_manifest_path) || contains(var.manifest_supported_versions, try(local.bootstrap_manifest.manifest_version, -1))
    error_message = "Bootstrap manifest must declare a supported manifest_version."
  }
}
