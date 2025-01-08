provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "azs" {}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command = "aws"
    args = [ "eks", "get-token", "--cluster-name", module.eks.cluster_name ]
  }
}

locals {
  cluster_name = var.cluster_name
}