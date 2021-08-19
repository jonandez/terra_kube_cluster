provider "aws" {
  # profile = "sys-admin-camilo"
  region = "us-east-1"
}

# terraform {
#   backend "s3" {
#     bucket = "cam-style-auto"
#     key = "terraform/learning-academy-terraform/prod/k8s-ex.tfstate"
#     region = "us-east-1"
#     profile = "sys-admin-camilo"
#   }
# }