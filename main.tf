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
  source = "./vpc.tf"
}

module "ecs" {
  source    = "./ecr.tf"
  subnet_id = module.vpc.ecs_subnet_id
}

module "ecr" {
  source = "./ecr.tf"
}

module "s3" {
  source                 = "./s3.tf"
  react_site_bucket_name = var.react_site_bucket_name
  letter_bucket_name     = var.letter_bucket_name
}

module "cloudfront" {
  source = "./cloudfront.tf"
}

output "ecs_service_name" {
  value = module.ecs.ecs_service_name
}

output "react_site_bucket" {
  value = module.s3.react_site_bucket
}

output "letter_bucket" {
  value = module.s3.letter_bucket
}

output "ecr_repo_url" {
  value = module.ecr.ecr_repo_url
}

output "cdn_url" {
  value = module.cloudfront.cdn_url
}
