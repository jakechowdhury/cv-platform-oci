<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_oci"></a> [oci](#provider\_oci) | 6.37.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [oci_containerengine_cluster.cv_platform](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/containerengine_cluster) | resource |
| [oci_containerengine_node_pool.cv_platform](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/containerengine_node_pool) | resource |
| [oci_containerengine_node_pool_option.oke](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/containerengine_node_pool_option) | data source |
| [oci_identity_availability_domains.ads](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_api_nsg_id"></a> [api\_nsg\_id](#input\_api\_nsg\_id) | OCID of the Network Security Group attached to the OKE API endpoint subnet | `string` | n/a | yes |
| <a name="input_api_subnet_id"></a> [api\_subnet\_id](#input\_api\_subnet\_id) | API endpoint subnet OCID — passed from network module output | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCI compartment OCID | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version for OKE cluster and node pool | `string` | `"v1.35.0"` | no |
| <a name="input_region"></a> [region](#input\_region) | OCI region | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key to authorise on worker nodes | `string` | n/a | yes |
| <a name="input_vcn_id"></a> [vcn\_id](#input\_vcn\_id) | VCN OCID — passed from network module output | `string` | n/a | yes |
| <a name="input_workers_subnet_id"></a> [workers\_subnet\_id](#input\_workers\_subnet\_id) | Worker nodes subnet OCID — passed from network module output | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | n/a |
<!-- END_TF_DOCS -->
