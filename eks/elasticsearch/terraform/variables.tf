variable "project" {
  description = "the project name"
}

variable "environment" {
  description = "the environment that this will run in"
}

variable "office-ips" {
  description = "office-ips to allow in to the ELB for TICK"
  type = "list"
}

variable "eks-nat-gws" {
  description = "The nat gateways that the eks clusters will send data from"
  type = "list"
}

variable "elasticsearch-instance-size" {
  description = "Public subnet ids for the elb"
}

variable "elasticsearch-ebs-volume-size" {
  description = "Private subnet id for the efs volumes to launch into"
}

