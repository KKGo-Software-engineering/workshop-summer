resource "aws_eks_cluster" "eks-cluster" {
	name     = var.cluster_name
	role_arn = aws_iam_role.eks_iam.arn

	vpc_config {
		subnet_ids = [
			aws_subnet.private-1a.id,
			aws_subnet.private-1b.id,
			aws_subnet.public-1a.id,
			aws_subnet.public-1b.id
		]
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

resource "kubernetes_namespace" "nginx_ingress" {
	metadata {
		name = var.ingress_namespace
	}

	depends_on = [aws_eks_cluster.eks-cluster]
}

resource "helm_release" "nginx_ingress" {
	namespace = kubernetes_namespace.nginx_ingress.metadata[0].name
	wait      = true
	timeout   = 600

	name = "ingress-nginx"

	repository = "https://kubernetes.github.io/ingress-nginx"
	chart      = "ingress-nginx"
	version    = "v4.10.1"
}

resource "kubernetes_namespace" "argocd" {
	metadata {
		name = var.argocd_namespace
	}
	depends_on = [aws_eks_cluster.eks-cluster]
}

resource "helm_release" "argocd" {
	namespace = kubernetes_namespace.argocd.metadata[0].name
	wait      = true
	timeout   = 600

	name = "argocd"

	repository = "https://argoproj.github.io/argo-helm"
	chart      = "argo-cd"
	version    = "6.7.17"
}

resource "null_resource" "ingress" {
	provisioner "local-exec" {
		command = "kubectl apply -f argocd-ingress.yaml"
	}
	depends_on = [helm_release.argocd]
}

data "kubernetes_service" "service" {
	metadata {
		name = "ingress-nginx-controller"
		namespace = "ingress-nginx"
	}
	depends_on = [null_resource.ingress]
}

resource "cloudflare_record" "argocd" {
	name    = "argocd"
	value   = data.kubernetes_service.service.status[0].load_balancer[0].ingress[0].hostname
	type    = "CNAME"
	proxied = true
	zone_id = var.zone_id
}
