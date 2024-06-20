variable "aws" {
  type = object({
    aws_region                = string
    aws_account               = string
    aws_role                  = string
    aws_identity_provider_arn = string
    aws_access_key            = string
    aws_secret_key            = string
  })
  description = <<EOT
  AWS configuration object. This object must contain the following properties:
  - aws_region: The AWS region to use.
  - aws_account: The AWS account ID.
  - aws_role: The AWS role to assume.
  - aws_identity_provider_arn: The ARN of the AWS identity provider.
  - aws_access_key: The AWS access key.
  - aws_secret_key: The AWS secret key.
  EOT
}

variable "vpc" {
  type = object({
    cidr_ip            = string
    private_subnet_ips = list(string)
    public_subnet_ips  = list(string)
  })
  description = <<EOT
  VPC configuration object. This object must contain the following properties:
  - cidr_ip: The CIDR block for the VPC.
  - private_subnet_ips: A list of private subnet IP addresses.
  - public_subnet_ips: A list of public subnet IP addresses.
  EOT
}

variable "opensearch" {
  type = object({
    master_user     = string
    master_password = string
  })
  description = <<EOT
  OpenSearch configuration object. This object must contain the following properties:
  - master_user: The OpenSearch master user.
  - master_password: The OpenSearch master password.
  EOT
}

variable "general" {
  type = object({
    environment   = string
    slack_webhook = string
    hosturl       = string
  })
  description = <<EOT
  General configuration object. This object must contain the following properties:
  - environment: The environment name.
  - slack_webhook: The Slack webhook URL.
  - hosturl: The host URL.
  EOT
}

variable "eks" {
  type = object({
    instance_types = list(string)
    min_size       = number
    max_size       = number
    desired_size   = number
    kms_key_owners = string
  })
  description = <<EOT
  EKS configuration object. This object must contain the following properties:
  - instance_types: A list of instance types for the EKS nodes.
  - min_size: The minimum number of nodes in the EKS cluster.
  - max_size: The maximum number of nodes in the EKS cluster.
  - desired_size: The desired number of nodes in the EKS cluster.
  - kms_key_owners: The AWS account IDs of the owners of the KMS key used to encrypt the EKS cluster.
  EOT
}


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
    github_repo_owner        = string

  })
  description = <<EOT
  GitHub configuration object. This object must contain the following properties:
  -backend_target_revision: The target revision of the backend Helm chart.
  - frontend_target_revision: The target revision of the frontend Helm chart.
  - helm_repo_url: The URL of the Helm repository.
  - backend_k8_path: The Kubernetes path of the backend Helm chart.
  EOT

}
