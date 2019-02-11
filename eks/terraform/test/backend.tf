terraform {
  backend "s3" {
    bucket = "terraform.state.main"
    key    = "andrew-eks-test-new/terraform.tfstate"
    region = "us-east-1"
  }
  required_version = "v0.11.7"
}
