terraform {

  required_version = "~> 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }

  }
#  portfolio-tf-state-tkg
  backend "s3" {
    # bucket       = "kts-tf-state-tkg"
    bucket       = "portfolio-tf-state-dns-kavindu"
    key          = "terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-south-1"
}


