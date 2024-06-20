terraform {
  backend "s3" {
    bucket         = "BUCKET_NAME"
    key            = "terraform/tfstate"
    region         = "us-east-1"
    use_path_style = true
    assume_role = {
      role_arn = "BUCKET_ROLE"
    }
  }
}
