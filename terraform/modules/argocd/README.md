<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 2.0 |
#### Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.13.2 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 2.0.4 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |
#### Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.argocd_apps](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_path_documents.argocd_apps_template](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/data-sources/path_documents) | data source |
| [template_file.argocd_values](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ecr"></a> [ecr](#input\_ecr) | ECR configuration object. This object must contain the following properties: app\_backend\_ecr\_uri, app\_frontend\_ecr\_uri | <pre>object({<br>    app_backend_ecr_uri  = string<br>    app_frontend_ecr_uri = string<br>  })</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_github"></a> [github](#input\_github) | GitHub configuration object. This object must contain the following properties:<br>  -backend\_target\_revision: The target revision of the backend Helm chart.<br>  - frontend\_target\_revision: The target revision of the frontend Helm chart.<br>  - helm\_repo\_url: The URL of the Helm repository.<br>  - backend\_k8\_path: The Kubernetes path of the backend Helm chart. | <pre>object({<br>    backend_target_revision  = string<br>    frontend_target_revision = string<br>    helm_repo_url            = string<br>    backend_k8_path          = string<br>    frontend_k8_path         = string<br>  })</pre> | n/a | yes |
| <a name="input_github_credentials"></a> [github\_credentials](#input\_github\_credentials) | Personal Credentials used to give access to the GitHub repository | <pre>object({<br>    pat  = string<br>    user = string<br>  })</pre> | n/a | yes |
| <a name="input_hosturl"></a> [hosturl](#input\_hosturl) | Host URL | `string` | n/a | yes |
#### Outputs

No outputs.
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
