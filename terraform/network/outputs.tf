output "vcn_id" {
  value = oci_core_vcn.cv_platform.id
}

output "workers_subnet_id" {
  value = oci_core_subnet.workers.id
}

output "api_subnet_id" {
  value = oci_core_subnet.api.id
}

output "api_nsg_id" {
  value = oci_core_network_security_group.api.id
}
