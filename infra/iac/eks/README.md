# Terraform for EKS
- Create EKS cluster
- Create VPC, Subnet, Route Table, Internet Gateway, NAT Gateway
- Install ArgoCD
- Install Nginx Ingress Controller
- Mapping DNS to ArgoCD (Cloudflare)


## K8s Credential

```sh
aws eks update-kubeconfig --name <CLUSTER_NAME>

aws eks update-kubeconfig --name eks-go-workshop
```

## Ingress Controller
- Enable `ssl-passthrough` via `'--enable-ssl-passthrough'` flag

```sh
kubectl -n ingress-nginx edit deployment.apps/ingress-nginx-controller
```

## Secret from ArgoCD

```sh
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

## ArgoCD Users
```sh

# create configmap file from argocd-cm
kubectl get configmap argocd-cm -n argocd -o yaml > argocd-cm.yml

# edit argocd-cm.yml
data:
 accounts.<ACCOUNT_NAME>: apiKey, login

# apply configmap
kubectl apply -f argocd-cm.yml -n argocd

# Set RBAC for the user
kubectl get configmap argocd-rbac-cm -n argocd -o yaml > argocd-rbac-cm.yml

# edit argocd-rbac-cm.yml
data:
  policy.csv: |
    g, <ACCOUNT_NAME>, role:admin

# apply configmap
kubectl apply -f argocd-rbac-cm.yml -n argocd

# login with argogo login
argocd login <ARGOCD_SERVER> --username <ACCOUNT_NAME> --password <PASSWORD>

# create password for new user
argocd account update-password --account <NEW_ACCOUNT_NAME> --current-password <ADMIN_PASSWORD> --new-password <NEW_PASSWORD>

# disable admin user if needed in argocd-cm.yml
data:
  admin.enabled: "false"
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8.0 |
| <a name="requirement_argocd"></a> [argocd](#requirement\_argocd) | >= 6.0.0, < 7.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | >= 4.0.0, < 5.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.13 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.0.0, < 2.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.0, < 3.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.47.0 |
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 4.30.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.13.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.29.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eks_cluster.eks-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.private-nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_role.eks_iam](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_iam-AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.workshop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [cloudflare_record.argocd](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nginx_ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.argocd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.nginx_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [null_resource.ingress](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_eks_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [kubernetes_service.service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_namespace"></a> [argocd\_namespace](#input\_argocd\_namespace) | The namespace where ArgoCD is installed | `string` | `"argocd"` | no |
| <a name="input_cloudflare_api_token"></a> [cloudflare\_api\_token](#input\_cloudflare\_api\_token) | Cloudflare API Token | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster | `string` | `"eks-go-workshop"` | no |
| <a name="input_eks_node_role"></a> [eks\_node\_role](#input\_eks\_node\_role) | The IAM role for the EKS nodes | `string` | `"eks-nodes-role"` | no |
| <a name="input_eks_role"></a> [eks\_role](#input\_eks\_role) | The IAM role for the EKS cluster | `string` | `"eks-go-workshop-role"` | no |
| <a name="input_ingress_namespace"></a> [ingress\_namespace](#input\_ingress\_namespace) | The namespace where the Ingress Controller is installed | `string` | `"ingress-nginx"` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Cloudflare Zone ID | `string` | `"460c65b55ec2a251ab45cf8eedac4734"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | n/a |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | n/a |
<!-- END_TF_DOCS -->
