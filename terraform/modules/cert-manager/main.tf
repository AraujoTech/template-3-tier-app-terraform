resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "prometheus.servicemonitor.enabled"
    value = "false"
  }

  #   set {
  #   name  = "prometheus.servicemonitor.namespace"
  #   value = "prometheus"
  # }

}

resource "kubectl_manifest" "issuer" {
  # for_each   = toset(data.kubectl_path_documents.argocd_apps_template.documents)
  yaml_body  = file("${path.module}/issuer.yaml")
  depends_on = [helm_release.cert_manager]
}
