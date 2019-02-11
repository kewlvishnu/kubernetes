variable "project" {
  description = "the project name"
}

variable "environment" {
  description = "the environment that this will run in"
}

variable "chronograf-ssl-cert-id" {
  description = "the ssl certificate id to use for https/ssl on the chronograf/influx elb"
}

variable "office-ips" {
  description = "office-ips to allow in to the ELB for TICK"
  type = "list"
}

variable "eks-nat-gws" {
  description = "The nat gateways that the eks clusters will send data from"
  type = "list"
}

variable "vpc-id" {
  description = "The vpc id of the vpc to deploy into"
}

variable "public-subnet-ids" {
  description = "Public subnet ids for the elb"
  type = "list"
}

variable "private-subnet-id" {
  description = "Private subnet id for the efs volumes to launch into"
}

