locals {
  oke_node_image_id = [
    for s in data.oci_containerengine_node_pool_option.oke.sources :
    s.image_id
    if strcontains(s.source_name, "aarch64") && strcontains(s.source_name, trimprefix(var.kubernetes_version, "v"))
  ][0]
}
