# --- Dynamic Discovery ---

# Resolve VCS integration by slug.
data "spacelift_github_enterprise_integration" "target" {
  id = var.vcs_integration_slug
}

# Resolve Space Admin role.
data "spacelift_role" "space_admin" {
  slug = "space-admin"
}
