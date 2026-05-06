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
| [oci_core_internet_gateway.cv_platform](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_network_security_group.api](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group_security_rule.api_egress_all](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.api_ingress_intra_vcn](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.api_ingress_kubectl](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_route_table.public](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_security_list.api](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_security_list.workers](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_subnet.api](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_subnet.workers](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_vcn.cv_platform](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vcn) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCI compartment OCID — use root compartment for simplicity | `string` | n/a | yes |
| <a name="input_my_ip_cidr"></a> [my\_ip\_cidr](#input\_my\_ip\_cidr) | Your home IP in CIDR notation (e.g. 1.2.3.4/32) for SSH and kubectl access | `string` | n/a | yes |
| <a name="input_oci_region"></a> [oci\_region](#input\_oci\_region) | OCI region | `string` | `"uk-london-1"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_nsg_id"></a> [api\_nsg\_id](#output\_api\_nsg\_id) | n/a |
| <a name="output_api_subnet_id"></a> [api\_subnet\_id](#output\_api\_subnet\_id) | n/a |
| <a name="output_vcn_id"></a> [vcn\_id](#output\_vcn\_id) | n/a |
| <a name="output_workers_subnet_id"></a> [workers\_subnet\_id](#output\_workers\_subnet\_id) | n/a |
<!-- END_TF_DOCS -->
