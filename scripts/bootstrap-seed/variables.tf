variable "spacelift_api_key_endpoint" {
  type        = string
  default     = "https://mnohava1987.app.us.spacelift.io"
  description = "The URL of your Spacelift account"
}

variable "vcs_namespace" {
  type        = string
  default     = "MNohava1987"
  description = "Your GitHub Organization or ADO Project"
}

variable "spacelift_api_key_id" {
  type        = string
  sensitive   = true
  description = "Spacelift API Key ID with Admin permissions"
}

variable "spacelift_api_key_secret" {
  type        = string
  sensitive   = true
  description = "Spacelift API Key Secret"
}

variable "vcs_integration_slug" {
  type        = string
  default     = "sl-github-vcs-integration"
  description = "The human-readable name of your VCS integration"
}

variable "enable_deletion_protection" {
  type        = bool
  default     = true
  description = "Toggles deletion protection for the foundational bootstrap stack."
}
