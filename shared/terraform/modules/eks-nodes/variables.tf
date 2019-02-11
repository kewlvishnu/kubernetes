variable "eks-endpoint" {
  description = "The endpoint for the eks cluster"
}

variable "eks-cluster-ca" {
  description = "The b64 encoded certificate authority for the eks cluster"
}

variable "eks-name" {
  description = "The eks cluster name"
}

variable "ec2-instance-type" {
  description = "The instance type for the nodes"
}

variable "ami-id" {
  description = "The ami-id to use for the nodes"
}

variable "keypair" {
  description = "The keypair to use for ssh into the nodes"
}

variable "iam-instance-profile" {
  description = "The iam instance profile name to use for the nodes"
}

variable "node-security-groups" {
  description = "The security groups for the nodes"
  type = "list"
}

variable "private-subnet-ids" {
  description = "The private subnet ids for the nodes"
  type = "list"
}

variable "desired-capacity" {
  description = "The desired capacity for the ASG"
}

variable "max-size" {
  description = "The max size for the ASG"
}

variable "min-size" {
  description = "The min size for the ASG"
}

variable "node-group-name" {
  description = "The nodes group name to use in the asg name"
}

variable "kubelet-extra-args" {
  description = "extra args to add to the kubelet startup bootstrap command. Useful for adding labels and taints"
  default = ""
}

