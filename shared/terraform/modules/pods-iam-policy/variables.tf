variable "project" {
  description = "The project that this is being used for."
}

variable "environment" {
  description = "The environment that this will be deployed to."
}

variable "path" {
  description = " (Optional, default /) Path in which to create the policy. See IAM Identifiers for more information.https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html"
  default = "/"
}

variable "policy" {
  description = "The policy JSON document that you are creating this policy with."
}

variable "pod-name" {
  description = "The policy JSON document that you are creating this policy with."
}