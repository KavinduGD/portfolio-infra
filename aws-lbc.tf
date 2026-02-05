data "http" "iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json"
}


resource "aws_iam_policy" "lbc_iam_policy" {
  name = "${var.project_name}-AWSLoadBalancerControllerIAMPolicy"
  # path just a policy organizing machanism
  path        = "/"
  description = "AWS Load Balancer Controller IAM Policy"
  policy      = data.http.iam_policy.response_body
}

module "lb_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.28.0"

  role_name = "${var.project_name}-aws-load-balancer-controller"

  role_policy_arns = {
    policy = aws_iam_policy.lbc_iam_policy.arn
  }
  # OpenID Connect
  # OIDC lets AWS trust identities that come from somewhere else
  # oidc_providers - who is allowed to assume the role
  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn
      # aws-load-balancer-controller is the service account
      # service account are identity for pod (like human use users to interact)
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

data "aws_region" "current" {}

resource "helm_release" "aws_lbc" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.17.0"

  values = [
    yamlencode({
      clusterName = module.eks.cluster_name
      region      = data.aws_region.current.id
      vpcId       = module.vpc.vpc_id
      serviceAccount = {
        create = true
        name   = "aws-load-balancer-controller"
        annotations = {
          "eks.amazonaws.com/role-arn" = module.lb_role.iam_role_arn
        }
      }
    })
  ]

  depends_on = [module.eks]
}
