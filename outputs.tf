output "ecs_service_name" {
  value = aws_ecs_service.node_service.name
}

output "react_site_bucket" {
  value = aws_s3_bucket.react_site.bucket
}

output "letter_bucket" {
  value = aws_s3_bucket.letter_bucket.bucket
}

output "ecr_repo_url" {
  value = aws_ecr_repository.node_repo.repository_url
}

output "cdn_url" {
  value = aws_cloudfront_distribution.react_cdn.domain_name
}
