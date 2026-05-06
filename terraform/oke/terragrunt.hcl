include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependency "network" {
  config_path = "../network"
}

inputs = {
  compartment_id    = include.root.locals.compartment_id
  region            = include.root.locals.region
  ssh_public_key    = include.root.locals.ssh_public_key
  vcn_id            = dependency.network.outputs.vcn_id
  api_subnet_id     = dependency.network.outputs.api_subnet_id
  workers_subnet_id = dependency.network.outputs.workers_subnet_id
  api_nsg_id        = dependency.network.outputs.api_nsg_id
}

generate "data" {
  path      = "data.tf"
  if_exists = "overwrite"
  contents  = <<EOF
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

data "oci_containerengine_node_pool_option" "oke" {
  node_pool_option_id = "all"
  compartment_id      = var.compartment_id
}

EOF
}
