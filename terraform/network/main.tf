resource "oci_core_vcn" "cv_platform" {
  compartment_id = var.compartment_id
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "cv-platform-vcn"
  dns_label      = "cvplatform"
}

resource "oci_core_internet_gateway" "cv_platform" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cv_platform.id
  display_name   = "cv-platform-igw"
  enabled        = true
}

resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cv_platform.id
  display_name   = "cv-platform-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.cv_platform.id
  }
}

resource "oci_core_security_list" "workers" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cv_platform.id
  display_name   = "cv-platform-workers-sl"

  # Allow all egress
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  # Allow intra-VCN traffic (node-to-node, control plane to workers)
  ingress_security_rules {
    source   = "10.0.0.0/16"
    protocol = "all"
  }

  # Traefik HTTPS NodePort — home IP only
  ingress_security_rules {
    source   = var.my_ip_cidr
    protocol = "6"
    tcp_options {
      min = 30443
      max = 30443
    }
    description = "Traefik HTTPS NodePort — home IP only"
  }

  # SSH from home IP only
  ingress_security_rules {
    source   = var.my_ip_cidr
    protocol = "6"
    tcp_options {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_subnet" "workers" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.cv_platform.id
  cidr_block        = "10.0.1.0/24"
  display_name      = "cv-platform-workers-subnet"
  dns_label         = "workers"
  route_table_id    = oci_core_route_table.public.id
  security_list_ids = [oci_core_security_list.workers.id]
}

resource "oci_core_security_list" "api" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cv_platform.id
  display_name   = "cv-platform-api-sl"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  # Allow kubectl from home IP
  ingress_security_rules {
    source   = var.my_ip_cidr
    protocol = "6"
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # Allow intra-VCN
  ingress_security_rules {
    source   = "10.0.0.0/16"
    protocol = "all"
  }
}

resource "oci_core_subnet" "api" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.cv_platform.id
  cidr_block                 = "10.0.0.0/28"
  display_name               = "cv-platform-api-subnet"
  dns_label                  = "api"
  route_table_id             = oci_core_route_table.public.id
  security_list_ids          = [oci_core_security_list.api.id]
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_network_security_group" "api" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cv_platform.id
  display_name   = "cv-platform-api-nsg"
}

resource "oci_core_network_security_group_security_rule" "api_ingress_kubectl" {
  network_security_group_id = oci_core_network_security_group.api.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.my_ip_cidr
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = 6443
      max = 6443
    }
  }
  description = "kubectl from home IP only"
}

resource "oci_core_network_security_group_security_rule" "api_ingress_intra_vcn" {
  network_security_group_id = oci_core_network_security_group.api.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source                    = "10.0.0.0/16"
  source_type               = "CIDR_BLOCK"
  description               = "Intra-VCN traffic"
}

resource "oci_core_network_security_group_security_rule" "api_egress_all" {
  network_security_group_id = oci_core_network_security_group.api.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}
