resource "aws_eks_cluster" "eks-cluster" {
	name     = var.cluster_name
	role_arn = aws_iam_role.eks_iam.arn
	version  = "1.29"

	vpc_config {
		subnet_ids = [
			aws_subnet.private-1a.id,
			aws_subnet.private-1b.id,
			aws_subnet.public-1a.id,
			aws_subnet.public-1b.id
		]
	}

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

	values = [
	]
}

resource "null_resource" "ingress" {
	provisioner "local-exec" {
		command = "kubectl apply -f argocd-ingress.yaml"
	}
	depends_on = [helm_release.argocd, helm_release.nginx_ingress]
}

data "kubernetes_service" "service" {
	metadata {
		name      = "ingress-nginx-controller"
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
