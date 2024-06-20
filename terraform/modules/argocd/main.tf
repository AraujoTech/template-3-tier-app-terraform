
data "template_file" "argocd_values" {
  template = file("${path.module}/values.yml")
}

resource "helm_release" "argocd" {
  name             = "argo"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  force_update     = true
  create_namespace = true
  values = [
    data.template_file.argocd_values.rendered
  ]
}

data "kubectl_path_documents" "argocd_apps_template" {
  pattern = "${path.module}/files/*.yaml"
  vars = {
    environment              = var.environment
    hostname                 = "argocd-${terraform.workspace}.${var.hosturl}"
    hosturl                  = var.hosturl
    workspace                = terraform.workspace
    frontend_image_uri       = var.ecr.app_frontend_ecr_uri
    backend_image_uri        = var.ecr.app_backend_ecr_uri
    backend_target_revision  = var.github.backend_target_revision
    frontend_target_revision = var.github.frontend_target_revision
    helm_repo_url            = var.github.helm_repo_url
    backend_k8_path          = var.github.backend_k8_path
    frontend_k8_path         = var.github.frontend_k8_path

  }
  sensitive_vars = {
    password = var.github_credentials.pat
    git_user = var.github_credentials.user
  }
}

resource "kubectl_manifest" "argocd_apps" {
  for_each   = toset(data.kubectl_path_documents.argocd_apps_template.documents)
  yaml_body  = each.value
  depends_on = [helm_release.argocd]
}
