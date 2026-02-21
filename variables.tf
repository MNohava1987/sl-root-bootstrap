variable "spacelift_api_key_id" { type = string; sensitive = true }
variable "spacelift_api_key_secret" { type = string; sensitive = true }

# GitHub VCS integration id in Spacelift UI (placeholder)
variable "vcs_integration_id" { type = string }

# Repo details
variable "admin_space_id" { type = string  default = "admin" } # you can keep admin stable by using explicit "admin" id
variable "admin_stacks_repo" { type = string  default = "sl-admin-stacks" }
variable "admin_stacks_branch" { type = string default = "main" }
