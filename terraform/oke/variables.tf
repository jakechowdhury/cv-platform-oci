variable "compartment_id" {
  description = "OCI compartment OCID"
  type        = string
}

variable "vcn_id" {
  description = "VCN OCID — passed from network module output"
  type        = string
}

variable "api_subnet_id" {
  description = "API endpoint subnet OCID — passed from network module output"
  type        = string
}

variable "workers_subnet_id" {
  description = "Worker nodes subnet OCID — passed from network module output"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for OKE cluster and node pool"
  type        = string
  default     = "v1.35.0"
}

variable "ssh_public_key" {
  description = "SSH public key to authorise on worker nodes"
  type        = string
}

variable "region" {
  description = "OCI region"
  type        = string
}

variable "api_nsg_id" {
  description = "OCID of the Network Security Group attached to the OKE API endpoint subnet"
  type        = string
}
