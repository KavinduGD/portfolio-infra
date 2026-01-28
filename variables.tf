# project variables

variable "project_name" {
  type        = string
  description = "name of the project"
}

variable "environment" {
  type        = string
  description = "Environment type (stage or production)"
}

#  vpc variables

variable "vpc_name" {
  type        = string
  description = "name of the vpc"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "list of cidr values of private subnets"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "list of cidr values of public subnets"
}

# eks variables

variable "eks_cluster_name" {
  type        = string
  description = "name of the eks cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "version of the kubernetes"
}