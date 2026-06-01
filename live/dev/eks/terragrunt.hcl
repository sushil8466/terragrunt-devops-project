include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/eks"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  environment = "dev"

  aws_region = "ap-south-1"

  vpc_id = dependency.vpc.outputs.vpc_id

  private_subnet_1_id = dependency.vpc.outputs.private_subnet_1_id

  private_subnet_2_id = dependency.vpc.outputs.private_subnet_2_id
}
