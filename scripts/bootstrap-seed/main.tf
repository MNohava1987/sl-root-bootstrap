terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
    }
  }
}

provider "spacelift" {}

# --- 1) DYNAMIC DISCOVERY ---

# Dynamically lookup the Space Admin role ID.
data "spacelift_role" "space_admin" {
  slug = "space-admin" 
}

# --- 2) BOOTSTRAP STACK ---

resource "spacelift_stack" "bootstrap" {
  name        = "sl-root-bootstrap"
  repository  = "sl-root-bootstrap"
  branch      = "main"
  space_id    = "root"
  description = "Foundational Bootstrap Stack (Zero-UI Seed - High Assurance)"

  # NO VCS INTEGRATION ID HERE.
  # It will automatically use the default integration configured in the account.

  protect_from_deletion = true
  enable_local_preview  = true
  autodeploy            = false 
}

# --- 3) PERMISSIONS ---

resource "spacelift_role_attachment" "bootstrap_admin" {
  space_id = "root"
  stack_id = spacelift_stack.bootstrap.id
  role_id  = data.spacelift_role.space_admin.id
}
