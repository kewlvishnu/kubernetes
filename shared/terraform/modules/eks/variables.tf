variable "project" {
  description = "the project name"
}

variable "environment" {
  description = "the environment that this will run in"
}

variable "api-access" {
  description = "a list of IPs to allow API access (kubectl) from"
  type = "list"
}

variable "public-subnet-ids" {
  description = "the public subnets to use for eks"
  type = "list"
}

variable "private-subnet-ids" {
  description = "the private subnets to use for eks. the nodes will be deployed into these"
  type = "list"
}

variable "vpc-id" {
  description = "the vpc to put everything in"
}

variable "eks-version" {
  description = "the eks version to use for the master/control plane cluster"
}
