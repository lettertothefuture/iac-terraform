terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# CONFIGURE THE AWS PROVIDER
provider "aws" {
  region = "us-east-1"
}
