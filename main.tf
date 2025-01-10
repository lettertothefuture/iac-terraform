# PROVIDER AWS
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


# NODE CLUSTER: ECS
resource "aws_ecs_cluster" "node_cluster" {
  name = "node-cluster"
}


resource "aws_ecs_task_definition" "node_task" {
  family             = "node-task"
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  network_mode       = "awsvpc"
  container_definitions = jsonencode([{
    name      = "node-container"
    image     = "${aws_ecr_repository.node_repo.repository_url}:latest"
    essential = true
    memory    = 512
    cpu       = 256
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])

  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
}

resource "aws_ecs_service" "node_service" {
  name            = "node-service"
  cluster         = aws_ecs_cluster.node_cluster.id
  task_definition = aws_ecs_task_definition.node_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = ["subnet-xxxxxx"] # Specify subnet IDs
    assign_public_ip = true
  }
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

output "ecs_service_name" {
  value = aws_ecs_service.node_service.name
}



# ECR: REPOSITORY
resource "aws_ecr_repository" "node_repo" {
  name                 = "node-app-repo"
  image_tag_mutability = "MUTABLE"
}

output "ecr_repo_url" {
  value = aws_ecr_repository.node_repo.repository_url
}

# BUCKT REACT WEB-PAGE
resource "aws_s3_bucket" "react_site" {
  bucket = "react-site-bucket"
  website {
    index_document = "index.html"
    # error_document = "error.html" # Optional
  }
}

output "react_site_bucket" {
  value = aws_s3_bucket.react_site.bucket
}

# BUCKET LETTERS
resource "aws_s3_bucket" "letter_bucket" {
  bucket = "letter-json-bucket"
}

output "letter_bucket" {
  value = aws_s3_bucket.letter_bucket.bucket
}





# CDN
resource "aws_cloudfront_distribution" "react_cdn" {
  origin {
    domain_name = aws_s3_bucket.react_site.bucket_regional_domain_name
    origin_id   = "S3-ReactSite"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-ReactSite"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100" # Choose the cheapest price class

  restrictions {
    geo_restriction {
      restriction_type = "none" # No geo restrictions
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "cdn_url" {
  value = aws_cloudfront_distribution.react_cdn.domain_name

}

