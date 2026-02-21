variable "vcs_integration_id" {
  type        = string
  description = "The ID of the default VCS integration (inherited from account)"
}

variable "admin_space_id" {
  type        = string
  default     = "root"
  description = "The parent space for environment containers"
}

variable "admin_stacks_repo" {
  type    = string
  default = "sl-admin-stacks"
}

variable "admin_stacks_branch" {
  type    = string
  default = "main"
}

variable "enable_auto_deploy" {
  type        = bool
  default     = false
  description = "Enables auto-deploy for the management plane orchestrators"
}
