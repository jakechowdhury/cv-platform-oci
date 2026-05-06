remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = get_env("S3_STATE_BUCKET")
    key     = "oci/${path_relative_to_include()}/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = local.is_k8s_oke ? "# Provider managed by k8s-oke generate block" : <<EOF
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.0"
    }
  }
}

provider "oci" {
  region              = var.region
  auth                = "APIKey"
  config_file_profile = "DEFAULT"
}
EOF
}
locals {
  region         = "uk-london-1"
  compartment_id = get_env("TF_VAR_compartment_id")
  ssh_public_key = file("~/.ssh/id_ed25519.pub")
  module_path        = path_relative_to_include()
  is_k8s_oke         = local.module_path == "terraform/k8s-oke"
}
