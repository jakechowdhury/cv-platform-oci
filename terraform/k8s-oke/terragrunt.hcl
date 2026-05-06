include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependency "oke" {
  config_path = "../oke"
}

inputs = {
  cluster_id        = dependency.oke.outputs.cluster_id
  region            = include.root.locals.region
}

locals {
  s3_bucket = get_env("S3_STATE_BUCKET")
  skip_root_provider_generate = true
}

generate "data" {
  path      = "data.tf"
  if_exists = "overwrite"
  contents  = <<EOF
data "terraform_remote_state" "cloudflare" {
  backend = "s3"
  config = {
    bucket  = "${local.s3_bucket}"
    key     = "cloudflare/terraform.tfstate"
    region  = "eu-west-2"
  }
}

data "oci_containerengine_cluster_kube_config" "oke" {
  cluster_id    = var.cluster_id
  token_version = "2.0.0"
}
EOF
}

generate "provider_override" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "kubectl" {
  host                   = local.kubeconfig["clusters"][0]["cluster"]["server"]
  cluster_ca_certificate = base64decode(local.kubeconfig["clusters"][0]["cluster"]["certificate-authority-data"])
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "oci"
    args        = ["ce", "cluster", "generate-token", "--cluster-id", var.cluster_id, "--region", var.region]
  }
}


provider "oci" {
  region              = var.region
  auth                = "APIKey"
  config_file_profile = "DEFAULT"
}


locals {
  kubeconfig = yamldecode(data.oci_containerengine_cluster_kube_config.oke.content)
}

provider "helm" {
  kubernetes = {
    host                   = local.kubeconfig["clusters"][0]["cluster"]["server"]
    cluster_ca_certificate = base64decode(local.kubeconfig["clusters"][0]["cluster"]["certificate-authority-data"])
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "oci"
      args        = ["ce", "cluster", "generate-token", "--cluster-id", var.cluster_id, "--region", var.region]
    }
  }
}

provider "kubernetes" {
  host                   = local.kubeconfig["clusters"][0]["cluster"]["server"]
  cluster_ca_certificate = base64decode(local.kubeconfig["clusters"][0]["cluster"]["certificate-authority-data"])
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "oci"
    args = [
      "ce", "cluster", "generate-token",
      "--cluster-id", var.cluster_id,
      "--region",     var.region
    ]
  }
}
EOF
}
