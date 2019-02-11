# EKS Nodes Module

Creates an ASG with nodes that will auto-connect to an EKS cluster.

## Input Variables
| Variable | Description | Default Value |
|----------|-------------|---------------|
| eks-endpoint | the endpoint for the eks cluster | - |
| eks-cluster-ca | the b64 encoded certificate authority for the eks cluster | - |
| eks-name | the eks cluster name | - |
| ec2-instance-type | the instance type for the nodes | - |
| keypair | the keypair to use for ssh into the nodess | - |
| iam-instance-profile | the iam instance profile name to use for the nodes | - |
| node-security-groups | the security groups for the nodes | - |
| private-subnet-ids | the private subnet ids for the nodes | - |
| desired-capacity | the desired capacity for the ASG | - |
| max-size | the max size for the ASG | - |
| min-size | the min size for the ASG | - |
| kubelet-extra-args | extra args to add to the kubelet startup bootstrap command. Useful for adding labels and taints | "" |


## Output Variables
| Variable | Description |
|----------|-------------|
| - | - |

## Example usage

````hcl
module "eks" {
  source = "../../../shared/terraform/modules/eks"
  project = "${var.project}"
  environment = "${var.environment}"
  api-access = "${var.api-access}"
  key = "${var.key}"
  public-subnet-ids = ["${aws_subnet.eks-public-subnets.*.id}"]
  private-subnet-ids = ["${aws_subnet.eks-private-subnets.*.id}"]
  vpc-id = "${aws_vpc.eks-vpc.id}"
}

module "nodes" {
  source = "../../../shared/terraform/modules/eks-nodes"
  eks-endpoint = "${module.eks.eks-endpoint}"
  eks-cluster-cs = "${module.eks.eks-cluster-ca}"
  eks-name = "${module.eks.eks-name}"
  ec2-instance-type = "t2.medium"
  keypair = "andrewm-devopsdev-fall"
  iam-instance-profile = "${module.eks.node-iam-instance-profile}"
  node-security-groups = "${module.eks.node-security-groups}"
  private-subnet-ids = "${aws_subnet.eks-private-subnets.*.id}"
  desired-capacity = 2
  min-size = 1
  max-size = 4
}
````
