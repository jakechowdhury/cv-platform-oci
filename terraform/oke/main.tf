resource "oci_containerengine_cluster" "cv_platform" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = "cv-platform-oke"
  vcn_id             = var.vcn_id
  type               = "BASIC_CLUSTER"

  endpoint_config {
    subnet_id            = var.api_subnet_id
    is_public_ip_enabled = true
    nsg_ids              = [var.api_nsg_id]
  }

  options {
    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }
    kubernetes_network_config {
      pods_cidr     = "10.244.0.0/16"
      services_cidr = "10.96.0.0/16"
    }
  }
}
resource "oci_containerengine_node_pool" "cv_platform" {
  cluster_id         = oci_containerengine_cluster.cv_platform.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = "cv-node-pool"
  node_shape         = "VM.Standard.A1.Flex"

  node_shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

  node_config_details {
    size                                = 2
    is_pv_encryption_in_transit_enabled = true

    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = var.workers_subnet_id
    }
  }

  node_source_details {
    source_type = "IMAGE"
    image_id    = local.oke_node_image_id
  }
}
