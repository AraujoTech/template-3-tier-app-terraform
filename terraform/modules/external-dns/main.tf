resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  namespace        = "external-dns"
  force_update     = true
  create_namespace = true
  set {
    name  = "image.pullPolicy"
    value = "Always"
  }


  set {
    name  = "provider"
    value = "aws"
  }


  set {
    name  = "policy"
    value = "upsert-only"
  }


  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "aws.credentials.secretKey"
    value = var.aws_secret_key

  }

  set {
    name  = "aws.credentials.accessKey"
    value = var.aws_access_key
  }

}
