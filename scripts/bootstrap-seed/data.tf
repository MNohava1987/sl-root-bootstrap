# --- DYNAMIC DISCOVERY ---

# Find the VCS ID using the provided Slug
data "spacelift_github_enterprise_integration" "target" {
  id = var.vcs_integration_slug
}

# Find the Space Admin Role ID
data "spacelift_role" "space_admin" {
  slug = "space-admin"
}
