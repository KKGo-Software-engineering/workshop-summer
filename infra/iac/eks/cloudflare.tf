data "kubernetes_service" "service" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
  depends_on = [helm_release.argocd]
}

resource "cloudflare_record" "argocd" {
  name    = "argocd"
  value   = data.kubernetes_service.service.status[0].load_balancer[0].ingress[0].hostname
  type    = "CNAME"
  proxied = true
  zone_id = var.zone_id
}

resource "cloudflare_record" "cnames-dev" {
  count   = length(var.subdomains)
  name    = "${var.subdomains[count.index]}-${var.batch_no}-dev"
  value   = data.kubernetes_service.service.status[0].load_balancer[0].ingress[0].hostname
  type    = "CNAME"
  proxied = true
  zone_id = var.zone_id
}

resource "cloudflare_record" "cnames-prod" {
  count   = length(var.subdomains)
  name    = "${var.subdomains[count.index]}-${var.batch_no}-prod"
  value   = data.kubernetes_service.service.status[0].load_balancer[0].ingress[0].hostname
  type    = "CNAME"
  proxied = true
  zone_id = var.zone_id
}
