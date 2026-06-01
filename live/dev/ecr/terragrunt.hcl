include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/ecr"
}

inputs = {
  aws_region      = "ap-south-1"
  repository_name = "terragrunt-devops-project-app"
}
