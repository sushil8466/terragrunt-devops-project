remote_state {
  backend = "s3"

  config = {
    bucket       = "project-devops-terragrunt"
    key          = "${path_relative_to_include()}/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
