terraform {
  backend "s3" {
    bucket = "eks-prod.terraform.state.main"
    key    = "eks-prod/terraform.tfstate"
    region = "us-east-1"
  }
  required_version = "v0.11.7"
}
