resource "kubernetes_namespace" "monitoring_namespace" {
  metadata {
    name = var.monitor_namespace
  }
}
