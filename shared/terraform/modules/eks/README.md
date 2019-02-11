# EKS Module

Creates an EKS cluster.

## Input Variables
| Variable | Description | Default Value |
|----------|-------------|---------------|
| project | the name of the project | - |
| environment | the environment that this is deployed to | - |
| api-access | list of IPs to allow API/kubectl access from | - |
| public-subnet-ids | a list of the public subnets to use for eks | - |
| private-subnet-ids | a list of the public subnets to use for eks (nodes go in these) | - |
| vpc-id | the vpc to deploy all resources into | - |


## Output Variables
| Variable | Description |
|----------|-------------|
| kubeconfig | the kubeconfig to use for kubectl |
| config-map-aws-auth | a k8s YAML config that needs to be applied to the cluster |
| eks-endpoint | the endpoint of the eks cluster |
| eks-cluster-ca | the eks cluster certificate authority |
| eks-name | the name of the eks cluster |
| node-iam-role-arn | the arn of the iam role for the nodes |
| node-iam-instance-profile | the name of the iam instance profile for nodes |
| node-security-groups | the security groups for nodes |

## Example usage

````hcl
module "eks" {
  source = "../../../shared/terraform/modules/eks"
  project = "${var.project}"
  environment = "${var.environment}"
  api-access = "${var.api-access}"
  public-subnet-ids = ["${aws_subnet.eks-public-subnets.*.id}"]
  private-subnet-ids = ["${aws_subnet.eks-private-subnets.*.id}"]
  vpc-id = "${aws_vpc.eks-vpc.id}"
}

output "kubeconfig" {
  sensitive = true
  value = "${module.eks.kubeconfig}"
}

output "config-map-aws-auth" {
  sensitive = true
  value = "${module.eks.config-map-aws-auth}"
}
````

## Extra Instructions
1. After the terraform finishes applying, you must get the kubeconfig from the terraform output.
`terraform output kubeconfig > ~/.kube/config`
2. As long as your credentials work for connecting to the cluster, you must then apply the config-map for aws-auth. This gives the ec2 nodes permission to connect to the cluster.
`terraform output config-map-aws-auth | kubectl apply -f -`

*Note*: Because of how EKS works, only the IAM user that made the cluster has RBAC permissions to access the kubectl API. To give permissions to other IAM users, you must edit the aws-auth config map to include user information. More info can be found here: [https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html). An example can be seen in projects/eks/Jenkinsfile and projects/eks/users.yml.
