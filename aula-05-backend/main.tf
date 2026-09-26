terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "TechNova"
      Purpose   = "Terraform Remote State"
      ManagedBy = "Terraform"
    }
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}