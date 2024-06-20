output "app_backend_ecr_uri" {
  value       = aws_ecr_repository.app.repository_url
  description = "ECR URI from backend app"
}

output "app_frontend_ecr_uri" {
  value       = aws_ecr_repository.app_frontend.repository_url
  description = "ECR URI from frontend app"
}
