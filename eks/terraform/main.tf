module "eks" {
  source = "../../shared/terraform/modules/eks"
  project = "${var.project}"
  environment = "${var.environment}"
  api-access = "${var.api-access}"
  public-subnet-ids = "${aws_subnet.eks-public-subnets.*.id}"
  private-subnet-ids = "${aws_subnet.eks-private-subnets.*.id}"
  vpc-id = "${aws_vpc.eks-vpc.id}"
  eks-version = "1.11"
}

module "nodes" {
  source = "../../shared/terraform/modules/eks-nodes"
  eks-endpoint = "${module.eks.eks-endpoint}"
  eks-cluster-ca = "${module.eks.eks-cluster-ca}"
  eks-name = "${module.eks.eks-name}"
  node-group-name = "t3.medium"
  ec2-instance-type = "t3.medium"
  ami-id = "ami-0b4eb1d8782fc3aea" # Kubernetes version 1.11.5
  keypair = "${var.ssh-key-name}"
  iam-instance-profile = "${module.eks.node-iam-instance-profile}"
  node-security-groups = "${module.eks.node-security-groups}"
  private-subnet-ids = "${aws_subnet.eks-private-subnets.*.id}"
  desired-capacity = 2
  min-size = 1
  max-size = 20
}

module "nodes-micro" {
  source = "../../shared/terraform/modules/eks-nodes"
  eks-endpoint = "${module.eks.eks-endpoint}"
  eks-cluster-ca = "${module.eks.eks-cluster-ca}"
  eks-name = "${module.eks.eks-name}"
  node-group-name = "t3.small"
  ec2-instance-type = "t3.small"
  ami-id = "ami-0b4eb1d8782fc3aea" # Kubernetes version 1.11.5
  keypair = "${var.ssh-key-name}"
  iam-instance-profile = "${module.eks.node-iam-instance-profile}"
  node-security-groups = "${module.eks.node-security-groups}"
  private-subnet-ids = "${aws_subnet.eks-private-subnets.*.id}"
  desired-capacity = 1
  min-size = 1
  max-size = 3
}

module "nodes-eks-components" {
  source = "../../shared/terraform/modules/eks-nodes"
  eks-endpoint = "${module.eks.eks-endpoint}"
  eks-cluster-ca = "${module.eks.eks-cluster-ca}"
  eks-name = "${module.eks.eks-name}"
  node-group-name = "eks-components-t3.medium"
  ec2-instance-type = "t3.medium"
  ami-id = "ami-0b4eb1d8782fc3aea" # Kubernetes version 1.11.5
  keypair = "${var.ssh-key-name}"
  iam-instance-profile = "${module.eks.node-iam-instance-profile}"
  node-security-groups = "${module.eks.node-security-groups}"
  private-subnet-ids = "${aws_subnet.eks-private-subnets.*.id}"
  desired-capacity = 1
  min-size = 1
  max-size = 2
  kubelet-extra-args = "--register-with-taints=node.kubernetes.io/unschedulable=true:NoSchedule --node-labels=dedicated=eks-components"
}

resource "aws_instance" "bastion-host" {
  subnet_id = "${aws_subnet.eks-public-subnets.*.id[0]}"
  vpc_security_group_ids = ["${module.eks.node-security-groups}"]
  instance_type = "t2.micro"
  ami = "ami-0f9cf087c1f27d9b1"
  key_name = "${var.ssh-key-name}"
  associate_public_ip_address = true

  tags {
    Name = "eks-${var.project}-${var.environment}-bastion-host"
    terraformManaged = true
  }
}

output "kubeconfig" {
  sensitive = true
  value = "${module.eks.kubeconfig}"
}

output "config-map-aws-auth" {
  sensitive = true
  value = "${module.eks.config-map-aws-auth}"
}

output "nat-gateway-ips" {
  value = ["${aws_nat_gateway.nat_gw.*.public_ip}"]
}

output "public-subnet-ids" {
  value = ["${aws_subnet.eks-public-subnets.*.id}"]
}

output "private-subnet-ids" {
  value = ["${aws_subnet.eks-private-subnets.*.id}"]
}

output "vpc-id" {
  value = "${aws_vpc.eks-vpc.id}"
}

output "node-role-arn" {
  value = "${module.eks.arn}"
}