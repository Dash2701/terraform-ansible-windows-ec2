# provider.tf

# Specify the provider and access details
provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}



terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.39.0"
    }
  }

  backend "s3" {
    bucket         = "tf-bucket-t3-pb-com"
    key            = "iam/terraform.tfstate"
    dynamodb_table = "tf-t3-state-locking"
    region         = "us-east-1"
    encrypt        = true
  }

  required_version = ">= 0.13"
}
