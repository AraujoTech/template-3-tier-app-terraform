variable "github_credentials" {
  type = object({
    pat  = string
    user = string
  })
  description = "Personal Credentials used to give access to the GitHub repository"
  sensitive   = true
}

variable "github" {
  type = object({
    backend_target_revision  = string
    frontend_target_revision = string
    helm_repo_url            = string
    backend_k8_path          = string
    frontend_k8_path         = string
  })
  description = <<EOT
  GitHub configuration object. This object must contain the following properties:
  -backend_target_revision: The target revision of the backend Helm chart.
  - frontend_target_revision: The target revision of the frontend Helm chart.
  - helm_repo_url: The URL of the Helm repository.
  - backend_k8_path: The Kubernetes path of the backend Helm chart.
  EOT

}


variable "environment" {
  type        = string
  description = "Environment"
}

variable "hosturl" {
  type        = string
  description = "Host URL"
}
variable "ecr" {
  type = object({
    app_backend_ecr_uri  = string
    app_frontend_ecr_uri = string
  })
  description = "ECR configuration object. This object must contain the following properties: app_backend_ecr_uri, app_frontend_ecr_uri"

}
