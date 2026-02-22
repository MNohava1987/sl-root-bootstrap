variable "enable_deletion_protection" {
  type        = bool
  default     = true
  description = "DANGER: If false, the Tier-0 bootstrap stack can be deleted. Keep true for normal operations."
}

variable "spacelift_api_key_endpoint" {
  type        = string
  default     = "https://mnohava1987.app.us.spacelift.io"
  description = "Spacelift account URL."
}

variable "vcs_namespace" {
  type        = string
  default     = "MNohava1987"
  description = "GitHub organization/user or Azure DevOps project."
}

variable "spacelift_api_key_id" {
  type        = string
  sensitive   = true
  description = "Spacelift API key ID with admin permissions."
}

variable "spacelift_api_key_secret" {
  type        = string
  sensitive   = true
  description = "Spacelift API key secret."
}

variable "vcs_integration_slug" {
  type        = string
  default     = "sl-github-vcs-integration"
  description = "Human-readable slug of the VCS integration."
}

variable "naming_org" {
  type        = string
  default     = "sl"
  description = "Organization token used by the naming convention."
}

variable "naming_env" {
  type        = string
  default     = "root"
  description = "Environment token used by the naming convention for seed resources."
}

variable "naming_domain" {
  type        = string
  default     = "mgmt"
  description = "Domain token used by the naming convention."
}

variable "naming_function_bootstrap" {
  type        = string
  default     = "bootstrap"
  description = "Function token for the Tier-0 bootstrap stack."
}

variable "naming_function_policy_git_flow" {
  type        = string
  default     = "git-flow"
  description = "Function token for the root git-flow policy."
}

variable "naming_function_policy_approval_law" {
  type        = string
  default     = "approval-law"
  description = "Function token for the root approval policy."
}

variable "bootstrap_stack_repository" {
  type        = string
  default     = "sl-root-bootstrap"
  description = "VCS repository used by the seeded bootstrap stack."
}

variable "bootstrap_stack_branch" {
  type        = string
  default     = "main"
  description = "VCS branch used by the seeded bootstrap stack."
}

variable "manifest_supported_versions" {
  type        = list(number)
  default     = [1]
  description = "Allowed schema versions for seed manifests/bootstrap/bootstrap-config.yaml."
}
