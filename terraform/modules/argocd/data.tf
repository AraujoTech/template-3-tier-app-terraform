# data "aws_ssm_parameters_by_path" "frontend" {
#   path = "/app/frontend/" # Trailing slash is optional
#   recursive = true
#   with_decryption = true
# }

# output "ssm" {
#     value = data.aws_ssm_parameters_by_path.frontend
# }
