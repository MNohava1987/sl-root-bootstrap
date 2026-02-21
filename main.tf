# 1) Admin space (use stable id "admin" for your trial)
resource "spacelift_space" "admin" {
  parent_space_id = var.admin_space_id
  name        = "Admin"
  description = "Admin control plane space"
}

# 2) Admin-stacks stack (the stack-of-stacks)
resource "spacelift_stack" "admin_stacks" {
  name        = "admin-stacks"
  description = "Creates/applies all other admin control plane stacks"
  space_id    = spacelift_space.admin.id

  # VCS wiring (GitHub)
  repository       = var.admin_stacks_repo
  branch           = var.admin_stacks_branch
  project_root     = "/" # adjust if repo is monorepo

  # Removed to use default
  # github_enterprise_id = var.vcs_integration_id
}

output "admin_space_id" {
  value = spacelift_space.admin.id
}

output "admin_stacks_stack_id" {
  value = spacelift_stack.admin_stacks.id
}
