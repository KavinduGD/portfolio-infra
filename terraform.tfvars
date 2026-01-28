# project variables

project_name = "porfolio"
environment  = "value"

# vpc variables

vpc_name = "portfolio-vpc"
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

# eks variables

eks_cluster_name   = "portfolio-eks-cluster"
kubernetes_version = "1.33"