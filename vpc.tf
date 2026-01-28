module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.azs.names, 0, 3)
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_vpn_gateway = false

  public_subnet_tags = {
    # This subnet is allowed to host PUBLIC load balancers
    "kubernetes.io/role/elb" = "1"
     # This subnet belongs to this EKS cluster , can be shared to another clusters
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }

  private_subnet_tags = {
    # This subnet is allowed to host PUBLIC load balancers
    "kubernetes.io/role/internal-elb" = "1"
    # This subnet belongs to this EKS cluster , can be shared to another clusters
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }

  tags = {
    
    project_name                                    = var.project_name
    environment                                     = var.environment
  }
}

