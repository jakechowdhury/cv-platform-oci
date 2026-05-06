variable "cluster_id" {
  description = "OKE cluster OCID — passed from oke module output via Terragrunt dependency"
  type        = string
}

variable "region" {
  description = "OCI region"
  type        = string
}

variable "ghcr_username" {
  description = "GitHub username for GHCR image pull"
  type        = string
  default     = "jakechowdhury"
}

variable "ghcr_token" {
  description = "GitHub PAT with read:packages scope for GHCR image pull"
  type        = string
  sensitive   = true
}
