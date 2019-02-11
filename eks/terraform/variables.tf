variable "project" {
  description = "the project name"
}

variable "environment" {
  description = "the environment that this will run in"
}

variable "api-access" {
  description = "the ips to give api access to"
  type = "list"
}

variable "vpc-cidr" {
  description = "cidr to use for the vpc"
}

variable "ssh-key-name" {
  description = "the ssh key for the nodes and the masters"
}

variable "newbits" {
  description = "the size of the subnets, for /24 use 2 if vpc cidr is /22"
}
