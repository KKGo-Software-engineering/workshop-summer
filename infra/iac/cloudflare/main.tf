data "aws_eks_cluster" "default" {
	name = var.cluster_name
}

data "aws_eks_cluster_auth" "default" {
	name = var.cluster_name
}

provider "kubernetes" {
	host                   = data.aws_eks_cluster.default.endpoint
	cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
	token                  = data.aws_eks_cluster_auth.default.token
}

data "kubernetes_service" "service" {
	metadata {
		name      = "ingress-nginx-controller"
		namespace = "ingress-nginx"
	}
	depends_on = [data.aws_eks_cluster.default]
}

resource "cloudflare_record" "cnames" {
	count   = length(var.subdomains)
	name    = "${var.subdomains[count.index]}-${var.batch_no}-${terraform.workspace}"
	value   = data.kubernetes_service.service.status[0].load_balancer[0].ingress[0].hostname
	type    = "CNAME"
	proxied = true
	zone_id = var.zone_id
}
