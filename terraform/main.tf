module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.general.environment}_${terraform.workspace}_VPC"
  cidr = var.vpc.cidr_ip

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = var.vpc.private_subnet_ips
  public_subnets  = var.vpc.public_subnet_ips

  public_subnet_names  = ["${var.general.environment}_PublicSubnet1", "${var.general.environment}_PublicSubnet2"]
  private_subnet_names = ["${var.general.environment}PrivateSubnet1", "${var.general.environment}_PrivateSubnet2"]

  enable_nat_gateway = true
  single_nat_gateway = true

}



module "opensearch" {
  source = "terraform-aws-modules/opensearch/aws"


  # Domain
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  advanced_security_options = {
    enabled                        = true
    anonymous_auth_enabled         = false
    internal_user_database_enabled = true

    master_user_options = {
      master_user_arn      = null
      master_user_name     = var.opensearch.master_user
      master_user_password = var.opensearch.master_password
    }
  }

  auto_tune_options = {
    desired_state = "DISABLED"

    maintenance_schedule = [
      {
        start_at                       = "2028-05-13T07:44:12Z"
        cron_expression_for_recurrence = "cron(0 0 ? * 1 *)"
        duration = {
          value = "2"
          unit  = "HOURS"
        }
      }
    ]

    rollback_on_disable = "NO_ROLLBACK"
  }

  cluster_config = {
    instance_count           = 2
    dedicated_master_enabled = false
    dedicated_master_type    = "t3.medium.search"
    instance_type            = "t3.medium.search"

    zone_awareness_config = {
      availability_zone_count = 2
    }

    zone_awareness_enabled = true
  }

  domain_endpoint_options = {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  domain_name = "${var.general.environment}-${terraform.workspace}-es"

  ebs_options = {
    ebs_enabled = true
    iops        = 3000
    throughput  = 125
    volume_type = "gp3"
    volume_size = 20
  }

  encrypt_at_rest = {
    enabled = true
  }

  engine_version = "OpenSearch_2.11"

  log_publishing_options = [
    { log_type = "INDEX_SLOW_LOGS" },
    { log_type = "SEARCH_SLOW_LOGS" },
  ]

  node_to_node_encryption = {
    enabled = true
  }

  software_update_options = {
    auto_software_update_enabled = true
  }

  # vpc_options = {
  #   subnet_ids = module.vpc.public_subnets
  # }

  # # VPC endpoint
  # vpc_endpoints = {
  #   one = {
  #     subnet_ids = module.vpc.public_subnets
  #   }
  # }

  # Access policy
  access_policy_statements = [
    {
      effect = "Allow"

      principals = [{
        type        = "*"
        identifiers = ["*"]
      }]

      actions = ["es:*"]

    }
  ]

  tags = {
    Terraform = "true"
  }
}

resource "aws_iam_role" "github_infra_access_role" {
  name = "GitHubInfraAccessRole"
  path = "/"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "${var.aws.aws_identity_provider_arn}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:${var.github.github_repo_owner}/*"
                }
            }
        }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "github_infra_access_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.github_infra_access_role.name
}

module "ecr" {
  source = "./modules/ecr"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.21.0"
  cluster_name    = "${var.general.environment}-${terraform.workspace}"
  cluster_version = "1.29"

  cluster_endpoint_public_access = true
  create_iam_role                = true
  kms_key_owners                 = [aws_iam_role.github_infra_access_role.arn, var.eks.kms_key_owners]

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.private_subnets
  control_plane_subnet_ids  = module.vpc.intra_subnets
  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = aws_iam_role.github_infra_access_role.arn
      username = "github-oidc-cluster-role"
      groups   = ["system:masters", "system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = module.karpenter.role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",

      ]
    },

    {
      rolearn  = "arn:aws:iam::${var.aws.aws_account}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_ba8c198085920b12/"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:masters",
        "system:bootstrappers",
        "system:nodes"
      ]

    }

  ]


  eks_managed_node_groups = {
    karpenter = {
      instance_types = var.eks.instance_types

      min_size     = var.eks.min_size
      max_size     = var.eks.max_size
      desired_size = var.eks.desired_size

      # taints = {
      #   # This Taint aims to keep just EKS Addons and Karpenter running on this MNG
      #   # The pods that do not tolerate this taint should run on nodes created by Karpenter
      #   addons = {
      #     key    = "CriticalAddonsOnly"
      #     value  = "false"
      #     effect = "NO_SCHEDULE"
      #   },
      # }
    }
  }

  tags = {
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    "karpenter.sh/discovery" = "${var.general.environment}-${terraform.workspace}"
  }

}


module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "19.21.0"


  cluster_name = module.eks.cluster_name

  irsa_oidc_provider_arn = module.eks.oidc_provider_arn

  # Attach additional IAM policies to the Karpenter node IAM role
  iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

  }

  tags = {
    Environment = var.general.environment
    Terraform   = "true"
  }
}

resource "kubectl_manifest" "github_cluster_role" {
  yaml_body  = <<YAML
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRole
  metadata:
    # "namespace" omitted since ClusterRoles are not namespaced
    name: github-oidc-cluster-role
  rules:
  - apiGroups: [""]
    resources: ["*"]
    verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
  YAML
  depends_on = [module.eks]
}

resource "kubectl_manifest" "github_cluster_role_binding" {
  yaml_body  = <<YAML
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRoleBinding
  metadata:
    name: github-oidc-cluster-role-binding
  subjects:
  - kind: User
    name: github-oidc-auth-user # Name is case sensitive
    apiGroup: rbac.authorization.k8s.io
  roleRef:
    kind: ClusterRole
    name: github-oidc-cluster-role
    apiGroup: rbac.authorization.k8s.io
  YAML
  depends_on = [module.eks]
}



module "cert_manager" {
  source = "./modules/cert-manager"
}

module "ingress" {
  source = "./modules/ingress-controller"
  # depends_on = [ module.cert_manager]
}



module "argocd" {
  source = "./modules/argocd"

  github = {
    backend_target_revision  = var.github.backend_target_revision
    frontend_target_revision = var.github.frontend_target_revision
    helm_repo_url            = var.github.helm_repo_url
    backend_k8_path          = var.github.backend_k8_path
    frontend_k8_path         = var.github.frontend_k8_path
  }

  github_credentials = {
    user = var.github_credentials.user
    pat  = var.github_credentials.pat
  }

  ecr = {
    app_backend_ecr_uri  = module.ecr.app_backend_ecr_uri
    app_frontend_ecr_uri = module.ecr.app_frontend_ecr_uri
  }

  environment = var.general.environment
  hosturl     = var.general.hosturl

}

module "external_dns" {
  source         = "./modules/external-dns"
  aws_access_key = var.aws.aws_access_key
  aws_secret_key = var.aws.aws_secret_key
}

module "monitoring" {
  source        = "./modules/monitoring"
  hosturl       = "nextfaze.ai"
  slack_webhook = var.general.slack_webhook

}
