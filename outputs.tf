output "environment_admin_spaces" {
  description = "Map of environment names to their Admin space IDs."
  value       = { for k, v in local.envs : k => spacelift_space.env_sub_space["${k}.admin"].id }
}

output "environment_containers" {
  description = "Map of environment names to their root container IDs."
  value       = { for k, v in spacelift_space.env_root : k => v.id }
}
