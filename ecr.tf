resource "aws_ecr_repository" "node_repo" {
  name                 = "node-app-repo"
  image_tag_mutability = "MUTABLE"
}

