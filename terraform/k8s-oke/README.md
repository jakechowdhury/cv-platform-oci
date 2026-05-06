<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 6.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.1.1 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.19.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |
| <a name="provider_oci"></a> [oci](#provider\_oci) | 6.37.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.argocd_root_application](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace_v1.cloudflared](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.cv_site](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_secret_v1.argocd_cv_gitops_repo](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_secret_v1.cloudflared_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_secret_v1.ghcr_pull_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [tls_private_key.argocd_cv_gitops](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [oci_containerengine_cluster_kube_config.oke](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/containerengine_cluster_kube_config) | data source |
| [terraform_remote_state.cloudflare](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | OKE cluster OCID — passed from oke module output via Terragrunt dependency | `string` | n/a | yes |
| <a name="input_ghcr_token"></a> [ghcr\_token](#input\_ghcr\_token) | GitHub PAT with read:packages scope for GHCR image pull | `string` | n/a | yes |
| <a name="input_ghcr_username"></a> [ghcr\_username](#input\_ghcr\_username) | GitHub username for GHCR image pull | `string` | `"jakechowdhury"` | no |
| <a name="input_region"></a> [region](#input\_region) | OCI region | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_argocd_cv_gitops_deploy_key_public"></a> [argocd\_cv\_gitops\_deploy\_key\_public](#output\_argocd\_cv\_gitops\_deploy\_key\_public) | Add this as a second read-only deploy key in the cv-gitops GitHub repo |
<!-- END_TF_DOCS -->
