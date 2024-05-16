# GitOps and Infrastructure as Code
- [GitOps](gitops) - `ArgoCD` will sync the configuration from here
  - [dev](gitops/dev) - `K8s` configuration for Dev environment
  - [prod](gitops/prod) - `K8s` configuration for Prod environment
  - **Secrets** - `K8s` secret, we've applied in `K8s` cluster
- [IaC](iac/README.md) - Use `Terraform` code for describe how infrastructure look like
