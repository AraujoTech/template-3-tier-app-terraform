<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
#### Requirements

No requirements.
#### Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.13.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.30.0 |
#### Resources

| Name | Type |
|------|------|
| [helm_release.kube_metrics_server](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.loki_logs](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.monitoring_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_issuer_name"></a> [cluster\_issuer\_name](#input\_cluster\_issuer\_name) | Cluster issuer name | `string` | `"letsencrypt-prod"` | no |
| <a name="input_grafana_admin_password"></a> [grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | `"admin"` | no |
| <a name="input_hosturl"></a> [hosturl](#input\_hosturl) | Host URL | `string` | n/a | yes |
| <a name="input_monitor_namespace"></a> [monitor\_namespace](#input\_monitor\_namespace) | Monitoring namespace | `string` | `"monitoring"` | no |
| <a name="input_slack_webhook"></a> [slack\_webhook](#input\_slack\_webhook) | Slack webhook URL | `string` | n/a | yes |
#### Outputs

No outputs.
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
