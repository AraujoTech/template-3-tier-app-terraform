<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.28.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.13.2 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.30.0 |
#### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.28.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | ~> 2.0 |
#### Resources

| Name | Type |
|------|------|
| [aws_iam_role.github_infra_access_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.github_infra_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubectl_manifest.github_cluster_role](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.github_cluster_role_binding](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws"></a> [aws](#input\_aws) | AWS configuration object. This object must contain the following properties:<br>  - aws\_region: The AWS region to use.<br>  - aws\_account: The AWS account ID.<br>  - aws\_role: The AWS role to assume.<br>  - aws\_identity\_provider\_arn: The ARN of the AWS identity provider.<br>  - aws\_access\_key: The AWS access key.<br>  - aws\_secret\_key: The AWS secret key. | <pre>object({<br>    aws_region                = string<br>    aws_account               = string<br>    aws_role                  = string<br>    aws_identity_provider_arn = string<br>    aws_access_key            = string<br>    aws_secret_key            = string<br>  })</pre> | n/a | yes |
| <a name="input_eks"></a> [eks](#input\_eks) | EKS configuration object. This object must contain the following properties:<br>  - instance\_types: A list of instance types for the EKS nodes.<br>  - min\_size: The minimum number of nodes in the EKS cluster.<br>  - max\_size: The maximum number of nodes in the EKS cluster.<br>  - desired\_size: The desired number of nodes in the EKS cluster.<br>  - kms\_key\_owners: The AWS account IDs of the owners of the KMS key used to encrypt the EKS cluster. | <pre>object({<br>    instance_types = list(string)<br>    min_size       = number<br>    max_size       = number<br>    desired_size   = number<br>    kms_key_owners = string<br>  })</pre> | n/a | yes |
| <a name="input_general"></a> [general](#input\_general) | General configuration object. This object must contain the following properties:<br>  - environment: The environment name.<br>  - github\_pat: The GitHub personal access token.<br>  - slack\_webhook: The Slack webhook URL.<br>  - github\_repo\_owner: The GitHub repository owner. | <pre>object({<br>    environment    = string<br>    github_pat     = string<br>    slack_webhook  = string<br>    github_repo_owner = string<br>  })</pre> | n/a | yes |
| <a name="input_opensearch"></a> [opensearch](#input\_opensearch) | OpenSearch configuration object. This object must contain the following properties:<br>  - master\_user: The OpenSearch master user.<br>  - master\_password: The OpenSearch master password. | <pre>object({<br>    master_user     = string<br>    master_password = string<br>  })</pre> | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | VPC configuration object. This object must contain the following properties:<br>  - cidr\_ip: The CIDR block for the VPC.<br>  - private\_subnet\_ips: A list of private subnet IP addresses.<br>  - public\_subnet\_ips: A list of public subnet IP addresses. | <pre>object({<br>    cidr_ip            = string<br>    private_subnet_ips = list(string)<br>    public_subnet_ips  = list(string)<br>  })</pre> | n/a | yes |
#### Outputs

No outputs.
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
