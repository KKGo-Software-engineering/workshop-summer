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

resource "argocd_application" "argocd_app" {
  count = length(var.argo_apps)
  metadata {
    name = "${var.argo_apps[count.index]}-${terraform.workspace}"
  }

  spec {
    project = "default"

    source {
      repo_url        = "https://github.com/KKGo-Software-engineering/workshop-summer-${var.argo_apps[count.index]}-${var.batch_no}"
      path            = "infra/gitops/${terraform.workspace}"
      target_revision = "main"
    }

    destination {
      server = "https://kubernetes.default.svc"
    }

    sync_policy {
      automated {
        prune     = false
        self_heal = true
      }
    }
  }

  depends_on = [data.aws_eks_cluster_auth.default, data.aws_eks_cluster.default]
}
