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

variable "enable_deletion_protection" {
  type        = bool
  default     = true
  description = "!!!!! DO NOT CHANGE THIS IF YOU DO NOT WANT THINGS TO GET DELETED IT ALLOWS DELETION OF FOUNDATIONAL INFRA!!!!!! "
}

variable "manifest_supported_versions" {
  type        = list(number)
  default     = [1]
  description = "Allowed schema versions for manifests/management-plane.yaml."
}

variable "allowed_assurance_tiers" {
  type        = list(string)
  default     = ["tier-0", "tier-1", "tier-2", "tier-3", "tier-10"]
  description = "Allowed assurance_tier values for environments in the management manifest."
}

variable "required_bootstrap_space_names" {
  type        = list(string)
  default     = ["admin"]
  description = "Bootstrap spaces that must always exist in manifests/management-plane.yaml."
}

variable "enforce_lowercase_environment_names" {
  type        = bool
  default     = false
  description = "When true, all environment names in the manifest must be lowercase."
}
