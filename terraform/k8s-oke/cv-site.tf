resource "kubernetes_namespace_v1" "cv_site" {
  metadata {
    name = "cv-site"
  }
}

resource "kubernetes_secret_v1" "ghcr_pull_secret" {
  metadata {
    name      = "ghcr-pull-secret"
    namespace = kubernetes_namespace_v1.cv_site.metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "ghcr.io" = {
          username = var.ghcr_username
          password = var.ghcr_token
          auth     = base64encode("${var.ghcr_username}:${var.ghcr_token}")
        }
      }
    })
  }
}
