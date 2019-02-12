terraform {
  backend "s3" {
    bucket = "eks1-preprod.terraform.state.main"
    key    = "eks-preprod/terraform.tfstate"
    region = "us-east-1"
  }
  required_version = "v0.11.10"
}
