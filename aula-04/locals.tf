locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }

  instance_profile_name = var.use_academy_instance_profile ? data.aws_iam_instance_profile.lab[0].name : aws_iam_instance_profile.api[0].name
}
