variable "spacelift_api_key_id" {
  type      = string
  sensitive = true
}

variable "spacelift_api_key_secret" {
  type      = string
  sensitive = true
}

variable "vcs_integration_id" {
  type        = string
  description = "GitHub VCS integration id in Spacelift UI"
}

variable "admin_space_id" {
  type        = string
  default     = "root"
  description = "Stable ID for the admin space"
}

variable "admin_stacks_repo" {
  type    = string
  default = "sl-admin-stacks"
}

variable "admin_stacks_branch" {
  type    = string
  default = "main"
}
