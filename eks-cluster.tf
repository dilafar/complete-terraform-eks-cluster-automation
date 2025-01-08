module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.16"

  cluster_name                   = var.cluster_name
  cluster_version                = var.k8_version
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  create_cluster_security_group = false
  create_node_security_group    = false

  manage_aws_auth_configmap = true
  aws_auth_roles = local.aws_k8s_role_mapping

  cluster_addons = {
    kube-proxy = {}
    vpc-cni    = {}
    coredns    = {}
  }

  eks_managed_node_groups = {
    initial = {
      instance_types = [var.instance_type]
      min_size       = 2
      max_size       = 8
      desired_size   = 4
    }
  }


  tags = {
    Environment = "${var.env_prefix}"
  }

}