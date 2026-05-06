resource "kubernetes_namespace_v1" "cloudflared" {
  metadata {
    name = "cloudflared"
  }
}

resource "kubernetes_secret_v1" "cloudflared_credentials" {
  metadata {
    name      = "cloudflared-credentials"
    namespace = kubernetes_namespace_v1.cloudflared.metadata[0].name
  }

  data = {
    token = data.terraform_remote_state.cloudflare.outputs.tunnel_token
  }

}
