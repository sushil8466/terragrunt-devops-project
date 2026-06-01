provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "app_repo" {
  name = var.repository_name

  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}
