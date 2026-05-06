# cv-platform-oci

Infrastructure-as-code for the OCI leg of the CV platform — provisions a managed OKE cluster on Oracle's Always Free tier and bootstraps it with ArgoCD. Part of a four-repo project alongside `cv-platform`, `cv-site`, and `cv-gitops`.

## Architecture

```
OCI (uk-london-1)
└── 2x ARM VMs (A1.Flex)  ←  Terraform
    └── OKE cluster
        ├── ArgoCD  ←  pulls from jakechowdhury/cv-gitops
        │   └── cv-site app (served from ghcr.io)
        └── cloudflared  ←  Cloudflare Zero Trust tunnel
            └── cv.jakechowdhury.co.uk
```

## Repository layout

```
├── terraform/
│   ├── network/    # VCN, subnets, internet gateway, security lists
│   ├── oke/        # OKE cluster and ARM node pool
│   └── k8s-oke/    # ArgoCD, cv-gitops deploy key, GHCR pull secret, cloudflared tunnel secret
└── renovate.json   # Automated dependency updates
```

## Prerequisites

- OCI account (Always Free tier, upgraded to PAYG for OKE)
- OCI CLI configured with a DEFAULT profile
- Cloudflare account with the domain managed there
- OpenTofu and Terragrunt installed locally

## Usage

### 1. Provision networking

```bash
cd terraform/network
terragrunt apply
```

### 2. Provision OKE cluster

```bash
cd terraform/oke
terragrunt apply
```

Once created, configure kubeconfig:

```bash
oci ce cluster create-kubeconfig \
  --cluster-id CLUSTER_ID \
  --file ~/.kube/oke-config \
  --region uk-london-1 \
  --token-version 2.0.0
```

### 3. Bootstrap cluster workloads

Export the kubeconfig before applying:

```bash
export KUBECONFIG=~/.kube/oke-config
```

```bash
cd terraform/k8s-oke
terragrunt apply
```

After apply, add the ArgoCD deploy key to `cv-gitops`:

```bash
# Copy this output and add it as a read-only deploy key in cv-gitops:
# GitHub → cv-gitops → Settings → Deploy keys → Add deploy key
terragrunt output argocd_cv_gitops_deploy_key_public
```

ArgoCD will then sync `clusters/oci/` from `cv-gitops` and deploy all workloads automatically.

## Teardown

Destroy in reverse order to avoid dependency errors.

### 1. Remove cluster workloads

```bash
cd terraform/k8s-oke
terragrunt destroy
```

### 2. Destroy OKE cluster

```bash
cd terraform/oke
terragrunt destroy
```

### 3. Destroy networking

```bash
cd terraform/network
terragrunt destroy
```

## Secrets

Copy `example.env` to `dev.env` and populate the values. Files matching `*.env` and `*.tfvars` are gitignored.

## Development

Pre-commit hooks enforce formatting, linting, and secret detection:

```bash
pip install pre-commit
pre-commit install
```
