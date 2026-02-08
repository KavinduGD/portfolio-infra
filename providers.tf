terraform {

  required_version = "~> 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }

    http = {
      source  = "hashicorp/http"
      version = "3.4.1"
    }
  }
#  portfolio-tf-state-tkg
  backend "s3" {
    # bucket       = "kts-tf-state-tkg"
    bucket       = "portfolio-tf-state-tkg"
    key          = "terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-south-1"
}


provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}



provider "helm" {
  kubernetes = {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(
      module.eks.cluster_certificate_authority_data
    )

    exec = {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}
