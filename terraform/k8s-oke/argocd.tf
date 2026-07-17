resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.9.1"
  namespace        = "argocd"
  create_namespace = true
  wait             = true
  timeout          = 300

  values = [file("${path.module}/helm-values/argocd.yaml")]


  lifecycle {
    ignore_changes = [set_sensitive]
  }
}

resource "tls_private_key" "argocd_cv_gitops" {
  algorithm = "ED25519"
}

resource "kubernetes_secret_v1" "argocd_cv_gitops_repo" {
  metadata {
    name      = "cv-gitops-repo"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    type          = "git"
    url           = "git@github.com:jakechowdhury/cv-gitops.git"
    sshPrivateKey = tls_private_key.argocd_cv_gitops.private_key_openssh
  }

  depends_on = [helm_release.argocd]
}

output "argocd_cv_gitops_deploy_key_public" {
  value       = tls_private_key.argocd_cv_gitops.public_key_openssh
  sensitive   = false
  description = "Add this as a second read-only deploy key in the cv-gitops GitHub repo"
}


resource "kubectl_manifest" "argocd_root_application" {
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: root
  namespace: argocd
spec:
  project: default
  source:
    repoURL: git@github.com:jakechowdhury/cv-gitops.git
    targetRevision: HEAD
    path: clusters
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
YAML

  depends_on = [
    helm_release.argocd,
    kubernetes_secret_v1.argocd_cv_gitops_repo
  ]
}
