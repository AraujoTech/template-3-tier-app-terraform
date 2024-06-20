resource "aws_ecr_repository" "app" {
  name = "app"

  image_scanning_configuration {
    scan_on_push = true
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_ecr_repository" "app_frontend" {
  name = "app_frontend"

  image_scanning_configuration {
    scan_on_push = true
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}
