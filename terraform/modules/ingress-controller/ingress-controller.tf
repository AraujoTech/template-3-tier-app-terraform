
resource "helm_release" "ingress_controller" {
  name             = "ingress-controller"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress"
  force_update     = true
  recreate_pods    = true
  wait             = true
  create_namespace = true
  timeout          = 3000
}
