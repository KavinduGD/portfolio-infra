module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.eks_cluster_name
  kubernetes_version = var.kubernetes_version

  # IAM Roles for Service Accounts
  # Kubernetes pods use AWS permissions securely, without putting AWS access keys inside containers.
  # default is also true
  enable_irsa = true



  addons = {
    coredns = {}
    # eks-pod-identity-agent = {
    #   before_compute = true
    # }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
      addon_version  = "v1.21.1-eksbuild.1"
    }
    aws-ebs-csi-driver = {
      addon_version               = "v1.55.0-eksbuild.2"
      service_account_role_arn    = module.ebs_csi_irsa_role.iam_role_arn
    }
    aws-efs-csi-driver = {
      addon_version            = "v2.3.0-eksbuild.1"
      service_account_role_arn = module.efs_csi_irsa_role.iam_role_arn
    }
  }

  # optional
  # if this false we have to connect to k8 api server from jump host (something inside of the vpc)
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id = module.vpc.vpc_id
  # worker nodes are created as auto scaling group and spread across different subnets
  subnet_ids = module.vpc.private_subnets

  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {

    worker-nodes = {

      ami_type = "AL2023_x86_64_STANDARD"

      instance_types = ["t3.large"]

      use_latest_ami_release_version = false
      # ami_release_version = "1.33.5-20260120"


      min_size     = 2
      desired_size = 2
      max_size     = 3
    }
  }

  tags = {
    project_name = var.project_name
    environment  = var.environment
  }
}

module "ebs_csi_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.28.0"

  role_name             = "${var.eks_cluster_name}-ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

module "efs_csi_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.28.0"

  role_name             = "${var.eks_cluster_name}-efs-csi"
  attach_efs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
    }
  }
}