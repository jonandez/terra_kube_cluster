provider "aws" {
  # profile = "sys-admin-camilo"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "my-terraform-state-s3-grupo-1"
    # key    = "terraform/terraform.tfstate"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}