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
| <a name="requirement_argocd"></a> [argocd](#requirement\_argocd) | 6.1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.48.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | 4.31.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.13 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.29.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.48.0 |
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 4.31.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.13 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.29.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.eks-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.private-nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_role.eks_iam](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_iam-AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [cloudflare_record.argocd](https://registry.terraform.io/providers/cloudflare/cloudflare/4.31.0/docs/resources/record) | resource |
| [cloudflare_record.cnames-dev](https://registry.terraform.io/providers/cloudflare/cloudflare/4.31.0/docs/resources/record) | resource |
| [cloudflare_record.cnames-prod](https://registry.terraform.io/providers/cloudflare/cloudflare/4.31.0/docs/resources/record) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nginx_ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_eks_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [kubernetes_service.service](https://registry.terraform.io/providers/hashicorp/kubernetes/2.29.0/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_namespace"></a> [argocd\_namespace](#input\_argocd\_namespace) | The namespace where ArgoCD is installed | `string` | `"argocd"` | no |
| <a name="input_batch_no"></a> [batch\_no](#input\_batch\_no) | Workshop batch number | `string` | `"b2"` | no |
| <a name="input_capacity_type"></a> [capacity\_type](#input\_capacity\_type) | The capacity type for the EKS nodes | `string` | n/a | yes |
| <a name="input_cloudflare_api_token"></a> [cloudflare\_api\_token](#input\_cloudflare\_api\_token) | Cloudflare API Token | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster | `string` | n/a | yes |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | The desired size of the EKS nodes | `number` | n/a | yes |
| <a name="input_eks_node_role"></a> [eks\_node\_role](#input\_eks\_node\_role) | The IAM role for the EKS nodes | `string` | `"eks-nodes-role"` | no |
| <a name="input_eks_role"></a> [eks\_role](#input\_eks\_role) | The IAM role for the EKS cluster | `string` | `"eks-go-workshop-role"` | no |
| <a name="input_igw_id"></a> [igw\_id](#input\_igw\_id) | The ID of the Internet Gateway | `string` | n/a | yes |
| <a name="input_ingress_namespace"></a> [ingress\_namespace](#input\_ingress\_namespace) | The namespace where the Ingress Controller is installed | `string` | `"ingress-nginx"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type for the EKS nodes | `string` | n/a | yes |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum size of the EKS nodes | `number` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum size of the EKS nodes | `number` | n/a | yes |
| <a name="input_nat_id"></a> [nat\_id](#input\_nat\_id) | ID of the NAT Gateway | `string` | n/a | yes |
| <a name="input_subdomains"></a> [subdomains](#input\_subdomains) | List of subdomains | `list(string)` | n/a | yes |
| <a name="input_subnet_private-1a"></a> [subnet\_private-1a](#input\_subnet\_private-1a) | ID of the private subnet in AZ 1a | `string` | n/a | yes |
| <a name="input_subnet_private-1b"></a> [subnet\_private-1b](#input\_subnet\_private-1b) | ID of the private subnet in AZ 1b | `string` | n/a | yes |
| <a name="input_subnet_private-1c"></a> [subnet\_private-1c](#input\_subnet\_private-1c) | ID of the private subnet in AZ 1c | `string` | n/a | yes |
| <a name="input_subnet_public-1a"></a> [subnet\_public-1a](#input\_subnet\_public-1a) | ID of the public subnet in AZ 1a | `string` | n/a | yes |
| <a name="input_subnet_public-1b"></a> [subnet\_public-1b](#input\_subnet\_public-1b) | ID of the public subnet in AZ 1b | `string` | n/a | yes |
| <a name="input_subnet_public-1c"></a> [subnet\_public-1c](#input\_subnet\_public-1c) | ID of the public subnet in AZ 1c | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Cloudflare Zone ID | `string` | `"460c65b55ec2a251ab45cf8eedac4734"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | n/a |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | n/a |
<!-- END_TF_DOCS -->
