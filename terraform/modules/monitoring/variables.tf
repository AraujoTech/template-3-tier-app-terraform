variable "monitor_namespace" {
  type        = string
  default     = "monitoring"
  description = "Monitoring namespace"
}

variable "grafana_admin_password" {
  type        = string
  default     = "admin"
  description = "Grafana admin password"
}
variable "slack_webhook" {
  type        = string
  description = "Slack webhook URL"
}

variable "cluster_issuer_name" {
  type        = string
  default     = "letsencrypt-prod"
  description = "Cluster issuer name"
}

variable "hosturl" {
  type        = string
  description = "Host URL"
}
