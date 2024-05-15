resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_iam.arn
  version  = "1.29"

  vpc_config {
    subnet_ids = [
      var.subnet_private-1a,
      var.subnet_private-1b,
      var.subnet_public-1a,
      var.subnet_public-1b
    ]
  }

  enabled_cluster_log_types = ["api", "audit"]

  timeouts {
    delete = "30m"
  }
  depends_on = [aws_iam_role_policy_attachment.eks_iam-AmazonEKSClusterPolicy]
}

data "aws_eks_cluster" "default" {
  name = aws_eks_cluster.eks-cluster.name
}

data "aws_eks_cluster_auth" "default" {
  name = aws_eks_cluster.eks-cluster.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.default.token
  }
}

resource "helm_release" "nginx_ingress" {
  namespace        = var.ingress_namespace
  wait             = true
  timeout          = 600
  create_namespace = true

  name = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "v4.10.1"

  values = [file("${path.module}/values/nginx.yaml")]
}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = var.argocd_namespace
  wait             = true
  timeout          = 600
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.7.17"

  values = [file("${path.module}/values/argocd.yaml")]

  depends_on = [helm_release.nginx_ingress]
}
