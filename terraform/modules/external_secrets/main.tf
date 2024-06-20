resource "helm_release" "external_secrets" {
  name             = "external_secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = "external-secrets"
  force_update     = true
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}
