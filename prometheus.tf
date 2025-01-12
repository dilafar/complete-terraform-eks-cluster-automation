resource "helm_release" "prometheus-community" {
  name             = "prometheus-community"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "67.9.0"
  namespace        = "monitoring"
  create_namespace = true
  depends_on       = [
    module.eks
  ]
}