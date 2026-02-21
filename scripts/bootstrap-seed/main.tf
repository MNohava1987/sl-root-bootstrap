terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
    }
  }
}

provider "spacelift" {}

variable "vcs_integration_id" { type = string }

# 1. Lookup the Space Admin role ID dynamically
data "spacelift_role" "space_admin" {
  slug = "space-admin" 
}

# 2. Create the Bootstrap Stack
resource "spacelift_stack" "bootstrap" {
  name        = "sl-root-bootstrap"
  repository  = "sl-root-bootstrap"
  branch      = "main"
  space_id    = "root"
  description = "Foundational Bootstrap Stack (Locally Seeded - High Assurance)"

  protect_from_deletion = true
  enable_local_preview  = true
  autodeploy            = false 
}

# 3. Grant it Space Admin Role on root
resource "spacelift_role_attachment" "bootstrap_admin" {
  space_id = "root"
  stack_id = spacelift_stack.bootstrap.id
  role_id  = data.spacelift_role.space_admin.id
}
