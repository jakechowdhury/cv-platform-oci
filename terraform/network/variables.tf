variable "compartment_id" {
  description = "OCI compartment OCID — use root compartment for simplicity"
  type        = string
}

variable "oci_region" {
  description = "OCI region"
  type        = string
  default     = "uk-london-1"
}

variable "my_ip_cidr" {
  description = "Your home IP in CIDR notation (e.g. 1.2.3.4/32) for SSH and kubectl access"
  type        = string
}

variable "region" {}
