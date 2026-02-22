output "environment_admin_spaces" {
  description = "Map of environment names to their Admin space IDs."
  value       = { for k, v in local.envs : k => spacelift_space.env_sub_space["${k}.admin"].id }
}

output "environment_containers" {
  description = "Map of environment names to their root container IDs."
  value       = { for k, v in spacelift_space.env_root : k => v.id }
}

output "role_profile_role_slugs" {
  description = "Map of role profile names to Spacelift role slugs used by downstream orchestrators."
  value       = local.role_profile_slugs
}

output "role_catalog" {
  description = "Map of role profile names to resolved Spacelift role IDs."
  value = merge(
    { for profile, role in spacelift_role.profile : profile => role.id },
    { for profile, slug in local.role_profile_slugs : profile => data.spacelift_role.role_by_slug[slug].id if contains(local.external_role_slugs, slug) }
  )
}
