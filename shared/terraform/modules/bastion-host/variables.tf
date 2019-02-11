variable "bastion-host-name" {
  description = "the name of this bastion host"
}

variable "vpc-id" {
  description = "the vpc to put this bastion in"
}

variable "whitelisted-cidr-blocks" {
  type = "list"
  description = "the cidr blocks to allow ingress to the bastion"
}

variable "num-sgs" {
  description = "the number of security groups being whitelisted"
}

variable "instance-sg-ids" {
  type        = "list"
  description = "the id of the security groups that should allow this bastion host to connect"
}

variable "public-subnet-id" {
  description = "the subnet to put this bastion host in"
}

variable "ssh-key-name" {
  description = "the name of the ssh key to allow access to this bastion host"
}

variable "ami-id" {
  description = "the base ami id"
}
