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
  region = "us-east-2"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ecs" {
  source    = "./modules/ecr"
  subnet_id = module.vpc.ecs_subnet_id
}

module "ecr" {
  source = "./modules/ecr"
}

module "s3" {
  source                 = "./modules/s3"
  react_site_bucket_name = var.react_site_bucket_name
  letter_bucket_name     = var.letter_bucket_name
}

module "cloudfront" {
  source = "./modules/cloudfront"
}
