module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.eks_cluster_name
  kubernetes_version = var.kubernetes_version

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
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

      instance_types = ["t3.medium"]

      min_size     = 0
      desired_size = 0
      max_size     = 3
    }
  }

  tags = {
    project_name = var.project_name
    environment  = var.environment
  }
}