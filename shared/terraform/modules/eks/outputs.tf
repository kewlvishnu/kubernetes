# output kubeconfig
locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks-cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks-cluster.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "eks-${var.project}-${var.environment}"
KUBECONFIG
}

output "kubeconfig" {
  sensitive = true
  value = "${local.kubeconfig}"
}


# Output yml file to apply to cluster
locals {
  config-map-aws-auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.eks-node-role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}

output "config-map-aws-auth" {
  sensitive = true
  value = "${local.config-map-aws-auth}"
}


# Outputs needed for nodes
output "eks-endpoint" {
  value = "${aws_eks_cluster.eks-cluster.endpoint}"
}

output "eks-cluster-ca" {
  value = "${aws_eks_cluster.eks-cluster.certificate_authority.0.data}"
}

output "eks-name" {
  value = "${aws_eks_cluster.eks-cluster.name}"
}

output "node-iam-instance-profile" {
  value = "${aws_iam_instance_profile.eks-node-role.name}"
}

output "node-iam-role-arn" {
  value = "${aws_iam_role.eks-node-role.arn}"
}

output "node-security-groups" {
  value = ["${aws_security_group.eks-cluster-node-sg.id}"]
}
