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

 # cluster_addons = {
 #   kube-proxy = {}
 #   vpc-cni    = {}
 #   coredns    = {}
  #}

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

module "eks_blueprints_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0" 

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
  }

  enable_aws_load_balancer_controller    = true
 # enable_karpenter                       = true
 # enable_kube_prometheus_stack           = true
  enable_metrics_server                  = true
  enable_external_dns                    = true
  enable_cluster_autoscaler = true

  cluster_autoscaler = {
    set = [
      {
        name = "extraArgs.scale-down-unneeded-time"
        value = "1m"
      }
    ]
  }
 
}
