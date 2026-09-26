terraform {
  backend "s3" {
    bucket         = "technova-terraform-state-48f8d227"
    key            = "aula-05/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "technova-terraform-locks"
    encrypt        = true
  }
}